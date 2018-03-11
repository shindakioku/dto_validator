import 'dart:async';
import 'dart:mirrors';

import 'rules_exception.dart';
import 'strategy.dart';
import 'rules.dart';

class Validator {
  Map<Map<String, dynamic>, Rules> _fields;
  Map<String, dynamic> _errors;

  /// Yourself validation rules
  Map<String, dynamic> _customs;

  Validator() {
    _fields = {};
    _errors = {};
    _customs = {};
  }

  /*
   *     var _custom = [new Custom(name: 'rule', handler: new RuleStrategy())];
   *     
   *     validator.setCustom(_custom);
   */
  void setCustom(List<Custom> c) {
    c.forEach((v) {
      _customs.addAll({v.name: v.callback ?? v.handler});
    });
  }

  /**
     * The general function for starting validation process.
     * [object] is your object of your DTO
     */
  Future<Map<String, dynamic>> validate(Object object) async {
    await _addFields(object);

    return check().then((_) => _errors);
  }

  /// This method how [validate] but only for others DTO in your main DTO
  void _addFields(Object object) {
    _makeFields(reflect(object));
  }

  /// Building your fields of DTO for [Validator]
  _makeFields(InstanceMirror reflectObject) {
    ClassMirror classMirror = reflectObject.type;
    var className = MirrorSystem.getName(classMirror.simpleName);

    classMirror.declarations.forEach((a, b) {
      if (a != classMirror.simpleName) {
        b.metadata.forEach((c) {
          if (null != c.reflectee.entity && c.reflectee.entity) {
            // If field is object of other dto
            return _makeFields(reflectObject.getField(a));
          }

          if (c.reflectee is Rules) {
            // For example, UserValidation.email
            var name = className + '.' + MirrorSystem.getName(b.simpleName);

            _fields.putIfAbsent({
              'name': name,
              'object': reflectObject,
              'value': reflectObject.getField(a)
            }, () => c.reflectee);
          }
        });
      }
    });
  }

  /// Checks validation rules
  Future check() async {
    var completer = new Completer();
    completer.complete(true);

    _fields.forEach((field, Rules rule) {
      if (null != rule.required && rule.required) {
        new ValidateRule(new RequiredRule())
            .execute(field, this, errorHandler: rule.errorHandler);
      }

      if (null != rule.min) {
        new ValidateRule(new MinRule()).execute(field, this,
            options: rule.min, errorHandler: rule.errorHandler);
      }

      if (null != rule.max) {
        new ValidateRule(new MaxRule()).execute(field, this,
            options: rule.max, errorHandler: rule.errorHandler);
      }

      // If custom rules
      if (rule.custom.isNotEmpty) {
        rule.custom.forEach((name, arguments) {
          // If validator have the implementation
          if (_customs.containsKey(name)) {
            var _handler = _customs[name];
            String fieldName = field['name'];

            // Is callback?
            if (_handler is HandlerRule) {
              try {
                _handler(fieldName, field['value'],
                    rule: rule, arguments: arguments);
              } on RulesException catch (e) {
                _addError(fieldName, e.message);
              }
            } else {
              // Is [Strategy]
              new ValidateRule(_handler).execute(field, this,
                  options: arguments, errorHandler: rule.errorHandler);
            }
          }
        });
      }
    });

    return completer.future;
  }

  void _addError(String name, String error) {
    _errors.putIfAbsent(name, () => error);
  }
}

class ValidateRule {
  Strategy _strategy;

  ValidateRule(this._strategy);

  void execute(Map fieldMain, Validator validator, {options, errorHandler}) {
    try {
      _strategy.validate(fieldMain['name'].toString(), fieldMain['value'],
          options: options);
    } on RulesException catch (e) {
      return _handlerRulesExceptions(e, errorHandler, fieldMain, validator);
    }
  }

  void _handlerRulesExceptions(
      RulesException e, errorHandler, Map fieldMain, Validator validator) {
    var ruleError = e.message;
    String name = fieldMain['name'].toString();

    // We must try to call #fieldError()
    if (errorHandler == ErrorHandler.object) {
      try {
        var _s = fieldMain['object'].invoke(
            new Symbol(name.toString().split('.').last + 'Error'),
            [_strategy.makeError()]);

        validator._addError(name, _s.reflectee);

        return;
      } catch (e) {}
    }

    // We must try to call #error()
    if (errorHandler == ErrorHandler.all) {
      try {
        var _s = fieldMain['object'].invoke(#error, [_strategy.makeError()]);

        validator._addError(name, _s.reflectee);

        return;
      } catch (e) {}
    }

    // We must try to call #fieldStringError()
    if (errorHandler == ErrorHandler.string) {
      try {
        var _s = fieldMain['object'].invoke(
            new Symbol(name.toString().split('.').last + 'StringError'),
            [ruleError]);

        validator._addError(name, _s.reflectee);

        return;
      } catch (e) {}
    }

    validator._addError(name, ruleError);
  }
}

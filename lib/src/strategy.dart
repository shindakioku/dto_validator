import 'rules_exception.dart';
import 'errors.dart';

import 'dart:mirrors';

class Strategy {
  /**
     * [field] - field name in DTO
     * [data] - value of field
     * [options] - If it`s your validator, then it`s the [List<dynamic>] from
     * annotation. For example:
     *
     *    @Rules(custom: const {'your_rule': const [1, 'test'] - Is arguments})
     */
  validate(String field, InstanceMirror data, {options});

  ValidatorError makeError();
}

class RequiredRule implements Strategy {
  String _field;
  String _error;

  @override
  validate(String field, InstanceMirror data, {options}) {
    _field = field;

    if (null == data.reflectee) {
      _error = 'Is required';

      throw new RulesException(_error);
    }
  }

  @override
  ValidatorError makeError() {
    return new RequiredError(_field, _error);
  }
}

class MinRule implements Strategy {
  String _field;
  String _error;
  int _min;

  @override
  validate(String field, InstanceMirror data, {options}) {
    _field = field;
    var _c;

    if (null == data.reflectee) {
      _error = 'You must call required with MIN because it can be null';
      throw new RulesException(_error);
    }

    try {
      _c = (data.reflectee is String)
          ? data.reflectee.toString().length
          : data.reflectee; // Add more types..
    } catch (e) {
      throw (e);
    }

    if (options > _c) {
      _error = 'Cannot be less than';
      _min = options;

      throw new RulesException('Cannot be less than ${options}');
    }
  }

  @override
  ValidatorError makeError() {
    return new MinError(_field, _error, _min);
  }
}

class MaxRule implements Strategy {
  String _field;
  String _error;
  int _max;

  @override
  validate(String field, InstanceMirror data, {options}) {
    var _c;
    _field = field;
    _max = options;

    if (null == data.reflectee) {
      _error = 'You must call required with MAX because it can be null';

      throw new RulesException(_error);
    }

    try {
      _c = (data.reflectee is String)
          ? data.reflectee.toString().length
          : data.reflectee; // Add more types..
    } catch (e) {
      throw (e);
    }

    if (options < _c) {
      _error = 'Cannot be more than';
      _max = options;

      throw new RulesException('Cannot be more than ${options}');
    }
  }

  @override
  ValidatorError makeError() {
    return new MaxError(_field, _error, _max);
  }
}

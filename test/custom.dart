import 'package:validator/validator.dart';

import 'dart:mirrors';

void customRuleCallback(String field, InstanceMirror data,
    {Rules rule, List<dynamic> arguments}) {
  throw new RulesException('Test callback');
}

void customRuleCallbackWithArguments(String field, InstanceMirror data,
    {Rules rule, List<dynamic> arguments}) {
  throw new RulesException('First: ${arguments[0]}, Second: ${arguments[1]}');
}

class CustomRuleError implements ValidatorError {
  String someError;

  CustomRuleError(this.someError);
}

class CustomRuleStrategy implements Strategy {
  String _error;

  @override
  validate(String field, InstanceMirror data, {options}) {
    _error = 'Some error';
    throw new RulesException(_error);
  }

  @override
  ValidatorError makeError() {
    return new CustomRuleError(_error);
  }
}

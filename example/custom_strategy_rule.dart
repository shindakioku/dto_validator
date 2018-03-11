import 'package:validator/dto_validator.dart';

import 'dart:mirrors';

class User {
  @Rules(
      required: true,
      custom: const {
        'test_rule': const [1, 'test']
      },
      errorHandler: ErrorHandler.all)
  String email;

  @Rules(required: true, min: 4, max: 6)
  String password;

  int sex;

  dynamic error(ValidatorError error) => '${error.field}';
}

class TestError implements ValidatorError {
  String someError;

  TestError(this.someError);
}

class TestStrategy implements Strategy {
  String _error;

  @override
  validate(String field, InstanceMirror data, {options}) {
    _error = 'Some error';
    throw new RulesException(_error);
  }

  @override
  ValidatorError makeError() {
    return new TestError(_error);
  }
}

void main() {
  var validator = new Validator();
  var testData = {'email': 'tt@gmail.com', 'password': '1', 'sex': 0};
  var testAvatar = {'id': 1, 'name': 'some-name.png', 'size': 20};

  var test = new User()
    ..email = testData['email']
    ..password = testData['password']
    ..sex = testData['sex'];

  var _custom = [new Custom(name: 'test_rule', handler: new TestStrategy())];
  validator.setCustom(_custom);

  validator
      .validate(test)
      // {User.email: Some error, User.password: Cannot be less than 4}
      // Its because > dynamic error(ValidatorError error) => '${error.field}';
      .then((errors) => print(errors))
      .catchError((e) => print('error: ${e}'));
}

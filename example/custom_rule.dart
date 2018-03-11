import 'package:validator/dto_validator.dart';

import 'dart:mirrors';

class User {
  @Rules(
      required: true,
      custom: const {
        'some_rule': const [0]
      },
      errorHandler: ErrorHandler.object)
  String email;

  @Rules(required: true, min: 4, max: 6, errorHandler: ErrorHandler.string)
  String password;

  @Rules(required: true, errorHandler: ErrorHandler.all)
  int sex;

  String error(ValidatorError error) => 'All errors.';

  String emailError(ValidatorError error) => ''; // Email error

  String passwordStringError(String error) => error; // Some error..
}

/// typedef void HandlerRule(String field, InstanceMirror data,{Rules rule,
/// List<dynamic> arguments});
void callbackRule(String field, InstanceMirror data,
    {Rules rule, List<dynamic> arguments}) {
  // You must throw [RulesException] or return null

  if (arguments[0] != 1) {
    // See the @Rules(custom) for User
    throw new RulesException('bz...');
  }
}

void main() async {
  var validator = new Validator();
  var _customs = [new Custom(name: 'some_rule', callback: callbackRule)];
  var user = new User()
    ..email = 'ssss@gmail.com'
    ..password = 'qwe123'
    ..sex = 1;

  validator.setCustom(_customs);

  validator
      .validate(user)
      .then((errors) => print(errors)) // User.email bzz
      .catchError((error) => print(error));
}

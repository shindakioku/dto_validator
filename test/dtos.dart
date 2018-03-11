import 'package:validator/src/rules.dart';
import 'package:validator/src/errors.dart';

class CommonUser {
  int id;

  @Rules(required: true)
  String name;

  @Rules(required: true, min: 5, max: 20)
  String email;
}

class Avatar {
  int id;

  @Rules(required: true)
  String path;
}

class UserWithAvatarEntity {
  int id;

  @Rules(required: true)
  String name;

  @Rules(required: true, min: 5, max: 20)
  String email;

  @Rules(entity: true)
  Avatar avatar;
}

class AvatarWithObjectError {
  int id;

  @Rules(required: true, errorHandler: ErrorHandler.object)
  String path;

  String pathError(ValidatorError error) =>
      'Avatar path error is ${error.error}';
}

class UserWithAvatarEntityWithStringError {
  int id;

  @Rules(required: true)
  String name;

  @Rules(required: true, min: 5, max: 20, errorHandler: ErrorHandler.string)
  String email;

  @Rules(entity: true)
  AvatarWithObjectError avatar;

  String emailStringError(String error) => 'Email error is: ${error}';
}

class AvatarUser1 {
  int id;

  @Rules(required: true)
  String path;
}

class Profile {
  @Rules(required: true)
  int userId;

  @Rules(required: true, min: 3)
  String password;
}

class UserWithAvatarEntityAndProfile {
  int id;

  @Rules(required: true)
  String name;

  @Rules(required: true, min: 5, max: 20)
  String email;

  @Rules(entity: true)
  AvatarUser1 avatar;

  @Rules(entity: true)
  Profile profile;
}

class UserWithHandlerButNotDefined {
  @Rules(required: true, errorHandler: ErrorHandler.object)
  String email;
}

class UserWithHandlerOfAllErrors {
  @Rules(required: true, errorHandler: ErrorHandler.all)
  String email;

  @Rules(required: true, max: 5, errorHandler: ErrorHandler.all)
  int phone;

  String error(ValidatorError error) => 'Error for field: ${error.field}';
}

class CustomRuleCallbackUser {
  @Rules(custom: const {'my_rule': const []})
  String email;
}

class CustomRuleCallbackUserWithArguments {
  @Rules(custom: const {'my_rule': const [1, 'name']})
  String email;
}

import 'package:validator/dto_validator.dart';
import 'package:test/test.dart';

import 'dtos.dart';
import 'custom.dart';

void main() {
  test('Test validator with common rules with no errors', () async {
    var validator = new Validator();
    var user = new CommonUser()
      ..id = 1
      ..name = 'User Name'
      ..email = 'email@gmail.com';

    var errors = await validator.validate(user);

    expect(errors.length, equals(0));
  });

  test('Test validator with common rules with required error', () async {
    var validator = new Validator();
    var user = new CommonUser()
      ..id = 1
      ..email = 'email@gmail.com';

    var errors = await validator.validate(user);

    expect(errors.length, equals(1));
    expect(errors['CommonUser.name'], equals('Is required'));
  });

  test('Test validator with common rules with min error', () async {
    var validator = new Validator();
    var user = new CommonUser()
      ..id = 1
      ..name = 'User name'
      ..email = 'emai';

    var errors = await validator.validate(user);

    expect(errors.length, equals(1));
    expect(errors['CommonUser.email'], equals('Cannot be less than 5'));
  });

  test('Test validator with common rules with max error', () async {
    var validator = new Validator();
    var user = new CommonUser()
      ..id = 1
      ..name = 'User name'
      ..email = 'emqweojqweojikqweiojqwjieoqojiwejiqwqwekai';

    var errors = await validator.validate(user);

    expect(errors.length, equals(1));
    expect(errors['CommonUser.email'], equals('Cannot be more than 20'));
  });

  test('Test validator rules with other dto in object without errors',
      () async {
    var validator = new Validator();
    var avatar = new Avatar()
      ..id = 2
      ..path = 'some-image.png';

    var user = new UserWithAvatarEntity()
      ..id = 1
      ..name = 'User name'
      ..email = 'iqwqwekai'
      ..avatar = avatar;

    var errors = await validator.validate(user);

    expect(errors.length, equals(0));
  });

  test(
      'Test validator rules with other dto in object with user and avatar error',
      () async {
    var validator = new Validator();
    var avatar = new Avatar()..id = 2;

    var user = new UserWithAvatarEntity()
      ..id = 1
      ..email = 'iqwqwekai'
      ..avatar = avatar;

    var errors = await validator.validate(user);

    expect(errors.length, equals(2));
    expect(errors['UserWithAvatarEntity.name'], equals('Is required'));
    expect(errors['Avatar.path'], equals('Is required'));
  });

  test(
      'Test validator rules with other dto in object with user and avatar error, and overridet errors',
      () async {
    var validator = new Validator();
    var avatar = new AvatarWithObjectError()..id = 2;

    var user = new UserWithAvatarEntityWithStringError()
      ..id = 1
      ..name = 'User name'
      ..avatar = avatar;

    var errors = await validator.validate(user);

    expect(errors.length, equals(2));
    expect(errors['UserWithAvatarEntityWithStringError.email'],
        equals('Email error is: Is required'));

    expect(errors['AvatarWithObjectError.path'],
        equals('Avatar path error is Is required'));
  });

  test('Test validator rules with other two`s dtos in object without errors',
      () async {
    var validator = new Validator();
    var avatar = new AvatarUser1()
      ..id = 2
      ..path = 'some-image.png';
    var profile = new Profile()
      ..userId = 1
      ..password = 'qwe12';

    var user = new UserWithAvatarEntityAndProfile()
      ..id = 1
      ..name = 'User name'
      ..email = 'sadkkqwek@gmail.com'
      ..avatar = avatar
      ..profile = profile;

    var errors = await validator.validate(user);

    expect(errors.length, equals(0));
  });

  test('Test validator rules with other two`s dtos in object with errors',
      () async {
    var validator = new Validator();
    var avatar = new AvatarUser1()..id = 2;
    var profile = new Profile()..password = 'qwe12';

    var user = new UserWithAvatarEntityAndProfile()
      ..id = 1
      ..name = 'User name'
      ..avatar = avatar
      ..profile = profile;

    var errors = await validator.validate(user);

    print(errors);
    expect(errors.length, equals(3));
    expect(
        errors['UserWithAvatarEntityAndProfile.email'], equals('Is required'));
    expect(errors['AvatarUser1.path'], equals('Is required'));
    expect(errors['Profile.userId'], equals('Is required'));
  });

  test(
      'Test validator with common rules and with handler error without definition',
      () async {
    var validator = new Validator();
    var user = new UserWithHandlerButNotDefined();
    var errors = await validator.validate(user);

    expect(errors.length, equals(1));
    expect(errors['UserWithHandlerButNotDefined.email'], equals('Is required'));
  });

  test('Test validator with common rules and with error handler for all errors',
      () async {
    var validator = new Validator();
    var user = new UserWithHandlerOfAllErrors()..phone = 2131231231231231231;
    var errors = await validator.validate(user);

    expect(errors.length, equals(2));
    expect(errors['UserWithHandlerOfAllErrors.email'],
        equals('Error for field: UserWithHandlerOfAllErrors.email'));
    expect(errors['UserWithHandlerOfAllErrors.phone'],
        equals('Error for field: UserWithHandlerOfAllErrors.phone'));
  });

  test('Add custom rule with callback without arguments', () async {
    var validator = new Validator();
    var customs = [new Custom(name: 'my_rule', callback: customRuleCallback)];
    var customCallback = new CustomRuleCallbackUser();

    validator.setCustom(customs);

    var errors = await validator.validate(customCallback);

    expect(errors.length, equals(1));
    expect(errors['CustomRuleCallbackUser.email'], equals('Test callback'));
  });

  test('Add custom rule with callback with arguments', () async {
    var validator = new Validator();
    var customs = [
      new Custom(name: 'my_rule', callback: customRuleCallbackWithArguments)
    ];
    var customCallback = new CustomRuleCallbackUserWithArguments();

    validator.setCustom(customs);

    var errors = await validator.validate(customCallback);

    expect(errors.length, equals(1));
    expect(errors['CustomRuleCallbackUserWithArguments.email'],
        equals('First: 1, Second: name'));
  });

  test('Add custom rule with strategy', () async {
    var validator = new Validator();
    var customs = [
      new Custom(name: 'my_rule', handler: new CustomRuleStrategy())
    ];
    var customCallback = new CustomRuleCallbackUser();

    validator.setCustom(customs);

    var errors = await validator.validate(customCallback);

    expect(errors.length, equals(1));
    expect(errors['CustomRuleCallbackUser.email'], equals('Some error'));
  });
}

import 'package:validator/dto_validator.dart';

class Avatar {
  int id;

  @Rules(required: true, max: 3)
  String path;
}

class User {
  @Rules(required: true, min: 5)
  String email;

  @Rules(required: true, min: 2)
  int id;

  @Rules(entity: true)
  Avatar avatar;
}

void main() async {
  var validator = new Validator();
  var validator1 = new Validator();

  var user = new User()
    ..id = 231
    ..email = 'some-email@gmail.com';

  var errorsUser = await validator.validate(user);
  print(errorsUser); // nothing

  var avatar = new Avatar()
    ..id = 2
    ..path = 'qqq.png';

  var user1 = new User()
    ..id = 1
    ..email = 'qweqweqwe@gmail.com'
    ..avatar = avatar;

  validator1
      .validate(user1)
      // {User.id: Cannot be less than 2, Avatar.path: Cannot be more than 3}
      .then((errors) => print(errors))
      .catchError((error) => print(error));
}

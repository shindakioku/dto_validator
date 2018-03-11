import 'package:validator/validator.dart';

class User {
  @Rules(min: 5)
  String email;

  @Rules(required: true, min: 5)
  int id;

  @Rules(required: true)
  String phone;
}

class User1 {
  @Rules(required: true, min: 5)
  String email;

  @Rules(required: true, max: 2)
  int id;

  @Rules(required: true)
  String phone;
}

void main() async {
  var validator = new Validator();
  var validator1 = new Validator();
  var user = new User()
    ..id = 2
    ..phone = '123123';

  var user1 = new User1()
    ..email = 'some-email@gmail.com'
    ..id = 2
    ..phone = '123123';

  var errorsUser = await validator.validate(user);

  // {User.email: You must call required with MIN because it can be null, User.id: Cannot be less than 5}
  print(errorsUser);

  validator1
      .validate(user1)
      .then((errors) => print(errors)) // {}
      .catchError((error) => print(error));
}

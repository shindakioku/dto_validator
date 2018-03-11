# dto_validator

A library for Dart backend developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

    import 'package:validator/validator.dart';
    
    class User {
      @Rules(min: 5)
      String email;
    
      @Rules(required: true, min: 5)
      int id;
    
      @Rules(required: true)
      String phone;
    }
    
    void main() async {
      var validator = new Validator();
      var user = new User()
      ..email = 'email@gmail.com'
        ..id = 2
        ..phone = '123123';
        
        var errors = await validator.validate(user);
        // {User.id: Cannot be less than 5}
        print(errors);
    }

For more examples see - 

`/examples`

## Tests
Run in console(from root directory)

`pub run test .`
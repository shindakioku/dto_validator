import 'dart:mirrors';

import 'strategy.dart';
import 'errors.dart';

/**
 * You can tell to validator how do you wanna handle errors
 *
 * [string] - fieldStringError(String error) => error;
 * [object] - fieldError([ValidatorError] error) => error.error;
 * [all] - This method will call error method for everyone error
 *      error([ValidatorError] error) => ...;
 */
enum ErrorHandler { string, object, all }

/// Callback for your custom validator.
typedef void HandlerRule(String field, InstanceMirror data,
    {Rules rule, List<dynamic> arguments});

/**
 * You can create a custom validation rule.
 *
 * [name] - Naming of rule
 * [callback] - your callback
 * [handler] - your strategy
 *
 * You can create callback or handler, but not the both
 */
class Custom {
  final String name;
  final HandlerRule callback;
  final Strategy handler;

  Custom({this.name, this.callback: null, this.handler: null});
}

class Rules {
  final bool required;
  final int min;
  final int max;
  final bool entity;
  final object;
  final ErrorHandler errorHandler;
  final Map<String, List<dynamic>> custom;

  const Rules(
      {this.required: null,
      this.min: null,
      this.max: null,
      this.entity: null,
      this.object: null,
      this.errorHandler: null,
      this.custom: const {}});
}

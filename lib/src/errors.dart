class ValidatorError {}

class RequiredError implements ValidatorError {
  final String field;
  final dynamic error;

  RequiredError(this.field, this.error);
}

class MinError implements ValidatorError {
  final String field;
  final dynamic error;
  final int min;

  MinError(this.field, this.error, this.min);
}

class MaxError implements ValidatorError {
  final String field;
  final dynamic error;
  final int max;

  MaxError(this.field, this.error, this.max);
}

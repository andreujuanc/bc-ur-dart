abstract class ExceptionBase {
  final String message;
  ExceptionBase(this.message);
}

class InvalidSchemeError implements ExceptionBase {
  String name = 'InvalidSchemeError';
  @override
  final String message = 'Invalid Scheme';
}

class InvalidPathLengthError implements ExceptionBase {
  String name = 'InvalidPathLengthError';
  @override
  final String message = 'Invalid Path';
}

class InvalidTypeError implements ExceptionBase {
  String name = 'InvalidTypeError';
  @override
  final String message = 'Invalid Type';
}

class InvalidSequenceComponentError implements ExceptionBase {
  String name = 'InvalidSequenceComponentError';
  @override
  final String message = 'Invalid Sequence Component';
}

class InvalidChecksumError implements ExceptionBase {
  String name = 'InvalidChecksumError';
  @override
  final String message = 'Invalid Checksum';
}

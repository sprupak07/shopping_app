class CustomException implements Exception {
  final String? message;

  CustomException({this.message = 'An unknown error occurred.'});

  @override
  String toString() {
    return '$message';
  }
}

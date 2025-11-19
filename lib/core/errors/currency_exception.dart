class CurrencyException implements Exception {
  final String message;

  CurrencyException(this.message);

  @override
  String toString() => 'CurrencyException: $message';
}

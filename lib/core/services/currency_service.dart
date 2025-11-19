abstract class CurrencyService {
  /// Converts [amount] from [fromCurrency] to [toCurrency].
  /// Returns the converted amount.
  Future<double> convert({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });

  /// Fetches the current exchange rate from [fromCurrency] to [toCurrency].
  Future<double> getExchangeRate(String fromCurrency, String toCurrency);
}

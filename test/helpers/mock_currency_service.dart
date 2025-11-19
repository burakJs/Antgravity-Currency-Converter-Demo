import 'package:antigravity_demo/core/services/currency_service.dart';

class MockCurrencyService implements CurrencyService {
  @override
  Future<double> convert({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    return amount * await getExchangeRate(fromCurrency, toCurrency);
  }

  @override
  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    // Mock rates relative to USD
    // USD: 1.0
    // EUR: 0.85
    // TRY: 30.0
    // MXN: 20.0

    if (fromCurrency == 'USD') {
      switch (toCurrency) {
        case 'EUR':
          return 0.85;
        case 'TRY':
          return 30.0;
        case 'MXN':
          return 20.0;
        case 'USD':
          return 1.0;
      }
    }

    // Simple cross rate logic for testing if needed, or just return 1.0
    return 1.0;
  }
}

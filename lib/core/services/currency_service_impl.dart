import 'package:antigravity_demo/core/network/network_manager.dart';

import '../errors/currency_exception.dart';
import 'currency_service.dart';

class CurrencyServiceImpl implements CurrencyService {
  final NetworkManager _networkManager;

  CurrencyServiceImpl(this._networkManager);

  @override
  Future<double> convert({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    if (amount < 0) {
      throw CurrencyException('Amount cannot be negative');
    }

    try {
      final rate = await getExchangeRate(fromCurrency, toCurrency);
      return amount * rate;
    } catch (e) {
      if (e is CurrencyException) rethrow;
      throw CurrencyException('Conversion failed: ${e.toString()}');
    }
  }

  @override
  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    if (fromCurrency == toCurrency) return 1.0;

    try {
      final data = await _networkManager.get(
        '/latest',
        queryParameters: {'from': fromCurrency, 'to': toCurrency},
      );

      if (data is! Map<String, dynamic>) {
        throw CurrencyException('Invalid response format');
      }

      if (!data.containsKey('rates')) {
        throw CurrencyException('Invalid response format');
      }

      final rates = data['rates'] as Map<String, dynamic>;
      final rate = rates[toCurrency];

      if (rate == null) {
        throw CurrencyException('Rate for $toCurrency not found');
      }

      // Ensure we return a double
      return (rate is int) ? rate.toDouble() : rate as double;
    } catch (e) {
      if (e is CurrencyException) rethrow;
      throw CurrencyException('Network error: ${e.toString()}');
    }
  }
}

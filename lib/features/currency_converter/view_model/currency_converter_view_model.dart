import 'package:flutter/foundation.dart';

import '../../../core/services/currency_service.dart';

class CurrencyConverterViewModel extends ChangeNotifier {
  final CurrencyService _currencyService;

  CurrencyConverterViewModel(this._currencyService);

  final Map<String, double> _rates = {};
  final Map<String, String> _values = {
    'USD': '',
    'TRY': '',
    'EUR': '',
    'MXN': '',
  };

  bool _isLoading = true;
  String? _error;
  String? _activeCurrency;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, String> get values => _values;

  Future<void> init() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch rates relative to USD
      final eur = await _currencyService.getExchangeRate('USD', 'EUR');
      final tryRate = await _currencyService.getExchangeRate('USD', 'TRY');
      final mxn = await _currencyService.getExchangeRate('USD', 'MXN');

      _rates['USD'] = 1.0;
      _rates['EUR'] = eur;
      _rates['TRY'] = tryRate;
      _rates['MXN'] = mxn;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateAmount(String currency, String value) {
    if (_activeCurrency != null && _activeCurrency != currency) return;

    _activeCurrency = currency;
    _values[currency] = value;

    if (value.isEmpty) {
      _clearAllExcept(currency);
      notifyListeners();
      _activeCurrency = null;
      return;
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      // Invalid input, just keep the text but don't convert
      notifyListeners();
      _activeCurrency = null;
      return;
    }

    _convertOthers(currency, amount);
    notifyListeners();
    _activeCurrency = null;
  }

  void _convertOthers(String baseCurrency, double amount) {
    // Convert baseAmount to USD first
    final baseRate = _rates[baseCurrency]!;
    final amountInUsd = amount / baseRate;

    _rates.forEach((targetCurrency, rate) {
      if (targetCurrency == baseCurrency) return;

      final convertedAmount = amountInUsd * rate;
      _values[targetCurrency] = convertedAmount.toStringAsFixed(2);
    });
  }

  void _clearAllExcept(String currency) {
    _values.keys.forEach((key) {
      if (key != currency) {
        _values[key] = '';
      }
    });
  }
}

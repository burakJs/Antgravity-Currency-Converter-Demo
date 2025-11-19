import 'package:antigravity_demo/core/errors/currency_exception.dart';
import 'package:antigravity_demo/core/network/network_manager.dart';
import 'package:antigravity_demo/core/services/currency_service.dart';
import 'package:antigravity_demo/core/services/currency_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNetworkManager implements NetworkManager {
  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (path == '/latest' && queryParameters?['to'] == 'EUR') {
      return {
        'amount': 1.0,
        'base': 'USD',
        'date': '2023-01-01',
        'rates': {'EUR': 0.85},
      };
    }

    if (queryParameters?['to'] == 'XXX') {
      // Simulate what DioNetworkManager might throw or return for error
      // But here we are testing the service logic, so let's say it throws an exception
      throw Exception('Not Found');
    }

    throw Exception('Error');
  }
}

void main() {
  late CurrencyService currencyService;
  late MockNetworkManager mockNetworkManager;

  setUp(() {
    mockNetworkManager = MockNetworkManager();
    currencyService = CurrencyServiceImpl(mockNetworkManager);
  });

  group('CurrencyService', () {
    test('should convert USD to EUR correctly using NetworkManager', () async {
      // Arrange
      const from = 'USD';
      const to = 'EUR';
      const amount = 100.0;

      // Act
      final result = await currencyService.convert(
        fromCurrency: from,
        toCurrency: to,
        amount: amount,
      );

      // Assert
      // 100 * 0.85 = 85.0
      expect(result, 85.0);
    });

    test('should throw CurrencyException when NetworkManager fails', () async {
      // Arrange
      const from = 'USD';
      const to = 'XXX'; // Unsupported
      const amount = 100.0;

      // Act & Assert
      expect(
        () => currencyService.convert(
          fromCurrency: from,
          toCurrency: to,
          amount: amount,
        ),
        throwsA(isA<CurrencyException>()),
      );
    });

    test('should throw CurrencyException for negative amount', () async {
      // Arrange
      const from = 'USD';
      const to = 'EUR';
      const amount = -10.0;

      // Act & Assert
      expect(
        () => currencyService.convert(
          fromCurrency: from,
          toCurrency: to,
          amount: amount,
        ),
        throwsA(isA<CurrencyException>()),
      );
    });
  });
}

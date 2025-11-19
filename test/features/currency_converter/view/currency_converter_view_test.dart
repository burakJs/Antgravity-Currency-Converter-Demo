import 'package:antigravity_demo/core/theme/theme_provider.dart';
import 'package:antigravity_demo/features/currency_converter/view/currency_converter_view.dart';
import 'package:antigravity_demo/features/currency_converter/view_model/currency_converter_view_model.dart';
import 'package:antigravity_demo/features/currency_converter/widgets/currency_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../helpers/mock_currency_service.dart';

void main() {
  late MockCurrencyService mockService;
  late CurrencyConverterViewModel viewModel;

  setUp(() {
    mockService = MockCurrencyService();
    viewModel = CurrencyConverterViewModel(mockService);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrencyConverterViewModel>.value(
          value: viewModel,
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const MaterialApp(home: CurrencyConverterView()),
    );
  }

  testWidgets('shows loading initially', (WidgetTester tester) async {
    // Arrange
    // We don't trigger init() manually here because the view does it in initState/PostFrame
    // But since we pass an existing ViewModel, if we want to test the *View's* triggering of init,
    // we should pass a fresh VM.

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish animations
    await tester.pumpAndSettle();
  });

  testWidgets('displays currency fields after loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('USD'), findsOneWidget);
    expect(find.text('EUR'), findsOneWidget);
    expect(find.text('TRY'), findsOneWidget);
    expect(find.text('MXN'), findsOneWidget);

    expect(find.byType(CurrencyInputField), findsNWidgets(4));
  });

  testWidgets('entering amount in USD updates other fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Find the TextField associated with USD
    // The widget structure is Card -> Padding -> Row -> [Container(Text('USD')), Expanded(TextField)]
    // We can find the widget that contains text 'USD', then find the sibling TextField.
    // Or simpler: Find the CurrencyInputField that has 'USD'.

    final usdFieldFinder = find.ancestor(
      of: find.text('USD'),
      matching: find.byType(CurrencyInputField),
    );

    final usdTextField = find.descendant(
      of: usdFieldFinder,
      matching: find.byType(TextField),
    );

    // Act: Enter 100 into USD
    await tester.enterText(usdTextField, '100');
    await tester
        .pumpAndSettle(); // Wait for listeners to notify and UI to rebuild

    // Assert
    // USD = 100
    // EUR = 100 * 0.85 = 85.00
    // TRY = 100 * 30.0 = 3000.00
    // MXN = 100 * 20.0 = 2000.00

    // Helper to find text in other fields
    String getValueForCurrency(String currency) {
      final fieldFinder = find.ancestor(
        of: find.text(currency),
        matching: find.byType(CurrencyInputField),
      );
      final textField = tester.widget<TextField>(
        find.descendant(of: fieldFinder, matching: find.byType(TextField)),
      );
      return textField.controller?.text ?? '';
    }

    expect(getValueForCurrency('EUR'), '85.00');
    expect(getValueForCurrency('TRY'), '3000.00');
    expect(getValueForCurrency('MXN'), '2000.00');
  });
}

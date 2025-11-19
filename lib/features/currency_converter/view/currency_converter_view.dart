import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_provider.dart';
import '../view_model/currency_converter_view_model.dart';
import '../widgets/currency_input_field.dart';

class CurrencyConverterView extends StatefulWidget {
  const CurrencyConverterView({super.key});

  @override
  State<CurrencyConverterView> createState() => _CurrencyConverterViewState();
}

class _CurrencyConverterViewState extends State<CurrencyConverterView> {
  @override
  void initState() {
    super.initState();
    // Initialize the ViewModel to fetch rates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyConverterViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CurrencyConverterViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.init(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCurrencyField('USD', viewModel),
                  _buildCurrencyField('TRY', viewModel),
                  _buildCurrencyField('EUR', viewModel),
                  _buildCurrencyField('MXN', viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrencyField(
    String code,
    CurrencyConverterViewModel viewModel,
  ) {
    return CurrencyInputField(
      currencyCode: code,
      value: viewModel.values[code] ?? '',
      onChanged: (value) => viewModel.updateAmount(code, value),
    );
  }
}

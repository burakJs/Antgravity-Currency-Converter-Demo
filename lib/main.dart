import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/dio_network_manager.dart';
import 'core/services/currency_service_impl.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/currency_converter/view/currency_converter_view.dart';
import 'features/currency_converter/view_model/currency_converter_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DioNetworkManager()),
        ProxyProvider<DioNetworkManager, CurrencyServiceImpl>(
          update: (_, networkManager, __) =>
              CurrencyServiceImpl(networkManager),
        ),
        ChangeNotifierProxyProvider<
          CurrencyServiceImpl,
          CurrencyConverterViewModel
        >(
          create: (context) =>
              CurrencyConverterViewModel(context.read<CurrencyServiceImpl>()),
          update: (_, service, viewModel) =>
              viewModel ?? CurrencyConverterViewModel(service),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Currency Converter',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const CurrencyConverterView(),
          );
        },
      ),
    );
  }
}

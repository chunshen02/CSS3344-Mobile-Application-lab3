import 'package:flutter/material.dart';

import 'viewmodels/cruise_booking_viewmodel.dart';
import 'views/cruise_booking_screen.dart';

void main() {
  runApp(const RajangCruiseApp());
}

/// Owns the ViewModel's lifecycle. The state itself lives in the ViewModel, so
/// it survives the layout change when the device rotates.
class RajangCruiseApp extends StatefulWidget {
  const RajangCruiseApp({super.key});

  @override
  State<RajangCruiseApp> createState() => _RajangCruiseAppState();
}

class _RajangCruiseAppState extends State<RajangCruiseApp> {
  static final ThemeData _lightTheme = _buildTheme(ThemeData.light());
  static final ThemeData _darkTheme = _buildTheme(ThemeData.dark());

  static ThemeData _buildTheme(ThemeData base) {
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: base.brightness,
      ),
    );
  }

  final CruiseBookingViewModel _viewModel = CruiseBookingViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) => MaterialApp(
        title: 'Rajang River Cruise',
        debugShowCheckedModeBanner: false,
        theme: _lightTheme,
        darkTheme: _darkTheme,
        themeMode: _viewModel.themeMode,
        home: child,
      ),
      child: CruiseBookingScreen(viewModel: _viewModel),
    );
  }
}

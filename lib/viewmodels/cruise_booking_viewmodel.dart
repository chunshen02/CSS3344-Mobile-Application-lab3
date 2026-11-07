import 'package:flutter/material.dart';

import '../models/cruise_destination.dart';

/// ViewModel layer: holds the booking state and business logic.
///
/// Views read the getters and call the methods here. Every change goes through
/// [notifyListeners], so widgets never keep their own copy of this state.
class CruiseBookingViewModel extends ChangeNotifier {
  CruiseBookingViewModel({
    this.destination = CruiseDestination.rajangRiver,
    DateTime? today,
  }) : firstBookableDate = DateUtils.dateOnly(today ?? DateTime.now()),
       _selectedPackage = destination.packages.first,
       _starCount = destination.initialStarCount {
    lastBookableDate = DateTime(
      firstBookableDate.year + 1,
      firstBookableDate.month,
      firstBookableDate.day,
    );
    _selectedDate = DateUtils.addDaysToDate(firstBookableDate, 7);
  }

  final CruiseDestination destination;

  /// Fixed when the ViewModel is created. If the limits were recalculated on
  /// each read, leaving the app open overnight could put [selectedDate] before
  /// the first date, and showDatePicker asserts against that.
  final DateTime firstBookableDate;
  late final DateTime lastBookableDate;

  late DateTime _selectedDate;
  String _selectedPackage;
  int _starCount;
  bool _isStarred = false;
  bool _isDarkMode = false;

  DateTime get selectedDate => _selectedDate;
  String get selectedPackage => _selectedPackage;
  List<String> get packages => destination.packages;
  int get starCount => _starCount;
  bool get isStarred => _isStarred;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// [selectedDate] as dd/MM/yyyy.
  String get formattedDate {
    final day = _selectedDate.day.toString().padLeft(2, '0');
    final month = _selectedDate.month.toString().padLeft(2, '0');
    return '$day/$month/${_selectedDate.year}';
  }

  String get callMessage => 'Calling ${destination.name}...';
  String get routeMessage => 'Finding route to ${destination.location}...';
  String get shareMessage => 'Sharing ${destination.name}...';

  /// Adds the user's star on the first tap and removes it on the next.
  void toggleStar() {
    _isStarred = !_isStarred;
    _starCount += _isStarred ? 1 : -1;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    final selected = DateUtils.dateOnly(date);
    if (selected == _selectedDate) return;
    _selectedDate = selected;
    notifyListeners();
  }

  /// Takes a nullable value to match DropdownButton.onChanged.
  void updatePackage(String? package) {
    if (package == null || package == _selectedPackage) return;
    _selectedPackage = package;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    if (isDark == _isDarkMode) return;
    _isDarkMode = isDark;
    notifyListeners();
  }
}

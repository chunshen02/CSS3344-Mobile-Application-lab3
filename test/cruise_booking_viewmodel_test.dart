import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_rejang_river_cruise_app/models/cruise_destination.dart';
import 'package:simple_rejang_river_cruise_app/viewmodels/cruise_booking_viewmodel.dart';

void main() {
  late CruiseBookingViewModel viewModel;
  late int notifications;

  setUp(() {
    viewModel = CruiseBookingViewModel(today: DateTime(2026, 11, 7, 15, 30));
    notifications = 0;
    viewModel.addListener(() => notifications++);
  });

  tearDown(() => viewModel.dispose());

  test('starts from the destination data', () {
    expect(viewModel.destination, CruiseDestination.rajangRiver);
    expect(viewModel.starCount, 43);
    expect(viewModel.isStarred, isFalse);
    expect(viewModel.selectedPackage, 'Private River Cruise');
    expect(viewModel.isDarkMode, isFalse);
    expect(viewModel.themeMode, ThemeMode.light);
  });

  test('offers the five cruise packages from the lab brief', () {
    expect(viewModel.packages, [
      'Private River Cruise',
      'Sunset Cruise',
      'Sunrise Cruise',
      'Rural Cruise',
      'SMI Park Cruise',
    ]);
  });

  test('bookable dates run from today to one year later', () {
    expect(viewModel.firstBookableDate, DateTime(2026, 11, 7));
    expect(viewModel.lastBookableDate, DateTime(2027, 11, 7));
    expect(viewModel.selectedDate, DateTime(2026, 11, 14));
  });

  test('toggleStar adds then removes one star', () {
    viewModel.toggleStar();
    expect(viewModel.starCount, 44);
    expect(viewModel.isStarred, isTrue);

    viewModel.toggleStar();
    expect(viewModel.starCount, 43);
    expect(viewModel.isStarred, isFalse);

    expect(notifications, 2);
  });

  test('updateDate stores the date and formats it as dd/MM/yyyy', () {
    viewModel.updateDate(DateTime(2027, 1, 5, 9, 45));

    expect(viewModel.selectedDate, DateTime(2027, 1, 5));
    expect(viewModel.formattedDate, '05/01/2027');
    expect(notifications, 1);
  });

  test('updateDate ignores the time when comparing dates', () {
    viewModel.updateDate(DateTime(2026, 11, 14, 23, 59));

    expect(notifications, 0);
  });

  test('updatePackage changes the selection', () {
    viewModel.updatePackage('Sunset Cruise');

    expect(viewModel.selectedPackage, 'Sunset Cruise');
    expect(notifications, 1);
  });

  test('updatePackage ignores null and the current value', () {
    viewModel.updatePackage(null);
    viewModel.updatePackage('Private River Cruise');

    expect(viewModel.selectedPackage, 'Private River Cruise');
    expect(notifications, 0);
  });

  test('setDarkMode switches the theme mode', () {
    viewModel.setDarkMode(true);
    expect(viewModel.isDarkMode, isTrue);
    expect(viewModel.themeMode, ThemeMode.dark);

    viewModel.setDarkMode(true);
    expect(notifications, 1);
  });
}

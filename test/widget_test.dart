import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_rejang_river_cruise_app/main.dart';
import 'package:simple_rejang_river_cruise_app/viewmodels/cruise_booking_viewmodel.dart';
import 'package:simple_rejang_river_cruise_app/views/cruise_booking_screen.dart';
import 'package:simple_rejang_river_cruise_app/views/widgets/header_image_widget.dart';
import 'package:simple_rejang_river_cruise_app/views/widgets/title_section_widget.dart';

const Size tallPortrait = Size(411, 1000);
const Size phoneLandscape = Size(890, 411);
const Size smallPortrait = Size(320, 568);
const Size smallLandscape = Size(568, 320);

void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps the screen with a fixed "today" so that date assertions are stable.
Future<CruiseBookingViewModel> pumpScreen(WidgetTester tester) async {
  setScreenSize(tester, tallPortrait);
  final viewModel = CruiseBookingViewModel(today: DateTime(2026, 11, 7));
  addTearDown(viewModel.dispose);
  await tester.pumpWidget(
    MaterialApp(home: CruiseBookingScreen(viewModel: viewModel)),
  );
  return viewModel;
}

Brightness appBrightness(WidgetTester tester) {
  return Theme.of(tester.element(find.byType(CruiseBookingScreen))).brightness;
}

void main() {
  group('layout', () {
    testWidgets('portrait stacks the image above the details', (tester) async {
      setScreenSize(tester, tallPortrait);
      await tester.pumpWidget(const RajangCruiseApp());

      final image = tester.getRect(find.byType(HeaderImageWidget));
      final title = tester.getRect(find.byType(TitleSectionWidget));

      expect(image.height, 240);
      expect(image.bottom, lessThanOrEqualTo(title.top));
      expect(image.left, title.left);
    });

    testWidgets('landscape places the image beside the details', (
      tester,
    ) async {
      setScreenSize(tester, phoneLandscape);
      await tester.pumpWidget(const RajangCruiseApp());

      final body = tester.getRect(find.byType(OrientationBuilder));
      final image = tester.getRect(find.byType(HeaderImageWidget));
      final title = tester.getRect(find.byType(TitleSectionWidget));

      expect(image.right, lessThanOrEqualTo(title.left));
      expect(image.top, title.top);
      expect(image.height, body.height);
    });

    testWidgets('rotating keeps the booking state', (tester) async {
      setScreenSize(tester, tallPortrait);
      await tester.pumpWidget(const RajangCruiseApp());

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(find.text('44'), findsOneWidget);

      tester.view.physicalSize = phoneLandscape;
      await tester.pump();

      expect(find.text('44'), findsOneWidget);
    });

    for (final size in [smallPortrait, smallLandscape]) {
      for (final isDark in [false, true]) {
        final mode = isDark ? 'dark' : 'light';

        testWidgets('fits and scrolls at $size in $mode mode', (tester) async {
          setScreenSize(tester, size);
          tester.platformDispatcher.textScaleFactorTestValue = 1.3;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final viewModel = CruiseBookingViewModel()..setDarkMode(isDark);
          addTearDown(viewModel.dispose);

          await tester.pumpWidget(
            MaterialApp(
              theme: isDark ? ThemeData.dark() : ThemeData.light(),
              home: CruiseBookingScreen(viewModel: viewModel),
            ),
          );
          await tester.drag(find.byType(ListView), const Offset(0, -2000));
          await tester.pumpAndSettle();

          expect(find.text('Dark Mode'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('header image', () {
    testWidgets('shows a placeholder when the file is missing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderImageWidget(
              imagePath: 'assets/images/missing.jpg',
              caption: 'Caption',
              height: 240,
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();

      expect(find.text('Add assets/images/missing.jpg'), findsOneWidget);
      expect(find.text('Caption'), findsOneWidget);
    });
  });

  group('title section', () {
    testWidgets('tapping the star updates the count both ways', (tester) async {
      await pumpScreen(tester);
      expect(find.text('43'), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(find.text('44'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(find.text('43'), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });
  });

  group('action bar', () {
    testWidgets('each button shows its own message', (tester) async {
      final viewModel = await pumpScreen(tester);
      final messages = {
        'CALL': viewModel.callMessage,
        'ROUTE': viewModel.routeMessage,
        'SHARE': viewModel.shareMessage,
      };

      for (final MapEntry(key: label, value: message) in messages.entries) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();

        expect(find.text(message), findsOneWidget);
      }
    });
  });

  group('booking controls', () {
    testWidgets('picking a date updates the label', (tester) async {
      final viewModel = await pumpScreen(tester);
      expect(find.text('14/11/2026'), findsOneWidget);

      await tester.tap(find.text('Visit Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('20'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('20/11/2026'), findsOneWidget);
      expect(viewModel.selectedDate, DateTime(2026, 11, 20));
    });

    testWidgets('cancelling the date picker keeps the date', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Visit Date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('14/11/2026'), findsOneWidget);
    });

    testWidgets('the dropdown lists every package and selects one', (
      tester,
    ) async {
      final viewModel = await pumpScreen(tester);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      for (final package in viewModel.packages) {
        expect(find.text(package), findsWidgets);
      }

      await tester.tap(find.text('Sunset Cruise').last);
      await tester.pumpAndSettle();

      expect(viewModel.selectedPackage, 'Sunset Cruise');
      expect(find.text('Sunset Cruise'), findsOneWidget);
    });

    testWidgets('the switch toggles the whole app theme', (tester) async {
      setScreenSize(tester, tallPortrait);
      await tester.pumpWidget(const RajangCruiseApp());
      expect(appBrightness(tester), Brightness.light);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(appBrightness(tester), Brightness.dark);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(appBrightness(tester), Brightness.light);
    });
  });
}

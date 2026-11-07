import 'package:flutter/material.dart';

import '../viewmodels/cruise_booking_viewmodel.dart';
import 'widgets/action_bar_widget.dart';
import 'widgets/booking_controls_widget.dart';
import 'widgets/description_widget.dart';
import 'widgets/header_image_widget.dart';
import 'widgets/title_section_widget.dart';

/// Assembles the sections into a portrait or landscape layout.
class CruiseBookingScreen extends StatelessWidget {
  const CruiseBookingScreen({super.key, required this.viewModel});

  static const double _portraitImageHeight = 240;

  final CruiseBookingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final destination = viewModel.destination;
    final colorScheme = Theme.of(context).colorScheme;

    final details = <Widget>[
      TitleSectionWidget(viewModel: viewModel),
      const Divider(height: 1, indent: 16, endIndent: 16),
      ActionBarWidget(viewModel: viewModel),
      const Divider(height: 1, indent: 16, endIndent: 16),
      DescriptionWidget(text: destination.description),
      BookingControlsWidget(viewModel: viewModel),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sibu River Cruise & Heritage'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return ListView(
                children: [
                  HeaderImageWidget(
                    imagePath: destination.imagePath,
                    caption: destination.imageCaption,
                    height: _portraitImageHeight,
                  ),
                  ...details,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: HeaderImageWidget(
                    imagePath: destination.imagePath,
                    caption: destination.imageCaption,
                  ),
                ),
                Expanded(flex: 3, child: ListView(children: details)),
              ],
            );
          },
        ),
      ),
    );
  }
}

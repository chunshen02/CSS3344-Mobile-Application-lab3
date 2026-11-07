import 'package:flutter/material.dart';

import '../../viewmodels/cruise_booking_viewmodel.dart';

/// PreferenceSection: date picker, cruise package dropdown and theme switch.
class BookingControlsWidget extends StatelessWidget {
  const BookingControlsWidget({super.key, required this.viewModel});

  final CruiseBookingViewModel viewModel;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate,
      firstDate: viewModel.firstBookableDate,
      lastDate: viewModel.lastBookableDate,
    );
    if (picked != null) viewModel.updateDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Trip Preferences',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Visit Date'),
              trailing: Text(
                viewModel.formattedDate,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _pickDate(context),
            ),
            ListTile(
              leading: const Icon(Icons.sailing),
              title: const Text('Cruise Package'),
              // In subtitle so that long names get the full tile width.
              subtitle: DropdownButton<String>(
                value: viewModel.selectedPackage,
                isExpanded: true,
                items: [
                  for (final package in viewModel.packages)
                    DropdownMenuItem(value: package, child: Text(package)),
                ],
                onChanged: viewModel.updatePackage,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: viewModel.isDarkMode,
                onChanged: viewModel.setDarkMode,
              ),
              onTap: () => viewModel.setDarkMode(!viewModel.isDarkMode),
            ),
          ],
        ),
      ),
    );
  }
}

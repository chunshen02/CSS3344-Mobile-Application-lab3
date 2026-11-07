import 'package:flutter/material.dart';

import '../../viewmodels/cruise_booking_viewmodel.dart';

/// TitleSection: destination name, location and the dynamic star counter.
class TitleSectionWidget extends StatelessWidget {
  const TitleSectionWidget({super.key, required this.viewModel});

  final CruiseBookingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final destination = viewModel.destination;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination.location,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) => FilledButton.tonalIcon(
              onPressed: viewModel.toggleStar,
              icon: Icon(
                viewModel.isStarred ? Icons.star : Icons.star_border,
                color: Colors.amber.shade700,
              ),
              label: Text('${viewModel.starCount}'),
            ),
          ),
        ],
      ),
    );
  }
}

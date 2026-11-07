import 'package:flutter/material.dart';

import '../../viewmodels/cruise_booking_viewmodel.dart';

/// ButtonSection: the CALL, ROUTE and SHARE buttons, evenly spaced.
class ActionBarWidget extends StatelessWidget {
  const ActionBarWidget({super.key, required this.viewModel});

  final CruiseBookingViewModel viewModel;

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.call,
          label: 'CALL',
          onTap: () => _showMessage(context, viewModel.callMessage),
        ),
        _ActionButton(
          icon: Icons.near_me,
          label: 'ROUTE',
          onTap: () => _showMessage(context, viewModel.routeMessage),
        ),
        _ActionButton(
          icon: Icons.share,
          label: 'SHARE',
          onTap: () => _showMessage(context, viewModel.shareMessage),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

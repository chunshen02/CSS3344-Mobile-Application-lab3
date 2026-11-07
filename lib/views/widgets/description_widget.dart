import 'package:flutter/material.dart';

/// TextSection: a padded descriptive paragraph.
class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

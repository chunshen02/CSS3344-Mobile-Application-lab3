import 'package:flutter/material.dart';

/// ImageSection: hero banner with a caption in the bottom-left corner.
///
/// When [height] is null the image fills its parent, which is how the
/// landscape left pane uses it.
class HeaderImageWidget extends StatelessWidget {
  const HeaderImageWidget({
    super.key,
    required this.imagePath,
    required this.caption,
    this.height,
  });

  final String imagePath;
  final String caption;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            semanticLabel: caption,
            // Shown until the photo is added to assets/images/.
            errorBuilder: (context, error, stackTrace) => ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Add $imagePath', textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

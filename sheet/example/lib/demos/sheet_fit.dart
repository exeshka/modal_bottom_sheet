import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Small action-sheet style content for [SheetFit.loose].
class SheetFitDemo extends StatelessWidget {
  const SheetFitDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Edit'),
              leading: const Icon(Icons.edit),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text('Copy'),
              leading: const Icon(Icons.content_copy),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text('Delete'),
              leading: const Icon(Icons.delete),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

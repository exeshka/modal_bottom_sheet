import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetPopScopeDemo extends StatelessWidget {
  const SheetPopScopeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final navigator = Navigator.of(context);
          showCupertinoDialog<void>(
            context: context,
            builder: (dialogContext) => CupertinoAlertDialog(
              title: const Text('Dismiss sheet?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Stay'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    navigator.pop();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        },
        child: const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('PopScope'),
          ),
          child: Center(
            child: Text('Drag down to dismiss — confirm dialog appears'),
          ),
        ),
      ),
    );
  }
}

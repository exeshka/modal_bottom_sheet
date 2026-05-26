import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetSnapStopsDemo extends StatelessWidget {
  const SheetSnapStopsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Snap stops'),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView(
            controller: PrimaryScrollController.of(context),
            children: const <Widget>[
              ListTile(
                title: Text('Drag the sheet'),
                subtitle: Text('Snaps at ~40% and full height'),
              ),
              ListTile(title: Text('Stop 0 — dismissed')),
              ListTile(title: Text('Stop 0.4 — mid')),
              ListTile(title: Text('Stop 1 — expanded')),
            ],
          ),
        ),
      ),
    );
  }
}

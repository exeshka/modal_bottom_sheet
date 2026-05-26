import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetScrollDemo extends StatelessWidget {
  const SheetScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Scrollable sheet'),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView.builder(
            controller: PrimaryScrollController.of(context),
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        ),
      ),
    );
  }
}

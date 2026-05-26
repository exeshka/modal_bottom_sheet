import 'package:flutter/cupertino.dart' hide CupertinoSheetRoute;
import 'package:flutter/material.dart';
import 'package:sheet/route.dart';

class SheetInsideSheetDemo extends StatelessWidget {
  const SheetInsideSheetDemo({super.key, this.reverse = false});

  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(reverse ? 'Reverse list' : 'Sheet inside sheet'),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView.builder(
            reverse: reverse,
            controller: PrimaryScrollController.of(context),
            itemCount: 50,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoSheetRoute<void>(
                      builder: (context) =>
                          SheetInsideSheetDemo(reverse: reverse),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

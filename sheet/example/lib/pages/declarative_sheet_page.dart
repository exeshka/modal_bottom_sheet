import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheet/route.dart';

import '../demos/sheet_scroll.dart';
import '../web_frame.dart';

/// Navigator 2.0 demo using [CupertinoSheetPage].
class DeclarativeSheetPageDemo extends StatefulWidget {
  const DeclarativeSheetPageDemo({super.key});

  @override
  State<DeclarativeSheetPageDemo> createState() =>
      _DeclarativeSheetPageDemoState();
}

class _DeclarativeSheetPageDemoState extends State<DeclarativeSheetPageDemo> {
  bool _sheetVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(platform: TargetPlatform.iOS),
      builder: (context, child) => WebFrame(child: child!),
      home: Navigator(
        pages: <Page<void>>[
          CupertinoPage<void>(
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: const Text('CupertinoSheetPage'),
                leading: CupertinoNavigationBarBackButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Declarative navigator: toggle the sheet page '
                        'in the pages list.',
                      ),
                    ),
                    CupertinoButton.filled(
                      onPressed: () =>
                          setState(() => _sheetVisible = !_sheetVisible),
                      child: Text(_sheetVisible ? 'Hide sheet' : 'Show sheet'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_sheetVisible)
            const CupertinoSheetPage<void>(
              child: SheetScrollDemo(),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          if (route.settings is CupertinoSheetPage) {
            setState(() => _sheetVisible = false);
          }
          return true;
        },
      ),
    );
  }
}

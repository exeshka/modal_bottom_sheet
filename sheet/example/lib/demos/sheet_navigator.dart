import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetNavigatorDemo extends StatelessWidget {
  const SheetNavigatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (innerContext) => CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Nested navigator'),
            ),
            child: SafeArea(
              bottom: false,
              child: ListView.builder(
                controller: PrimaryScrollController.of(innerContext),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Push page $index'),
                    onTap: () {
                      Navigator.of(innerContext).push(
                        CupertinoPageRoute<void>(
                          builder: (context) => CupertinoPageScaffold(
                            navigationBar: CupertinoNavigationBar(
                              middle: Text('Detail $index'),
                              leading: CupertinoNavigationBarBackButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                              ),
                            ),
                            child: Center(
                              child: CupertinoButton.filled(
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                                child: const Text('Pop'),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

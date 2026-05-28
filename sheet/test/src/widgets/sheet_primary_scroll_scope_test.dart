import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheet/sheet.dart';

import '../../helpers.dart';

void main() {
  testWidgets('keeps a separate primary scroll controller per route',
      (WidgetTester tester) async {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    ScrollController? listController;
    ScrollController? detailController;

    await tester.pumpApp(
      Sheet(
        resizable: true,
        initialExtent: 600,
        maxExtent: 600,
        child: SheetPrimaryScrollScope(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              return CupertinoPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) {
                  if (settings.name == '/detail') {
                    return SheetPrimaryScrollScope(
                      child: Builder(
                        builder: (BuildContext context) {
                          detailController =
                              SheetPrimaryScrollScope.controllerOf(context);
                          return ListView.builder(
                            itemCount: 40,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 80,
                                child: Text('Detail $index'),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return SheetPrimaryScrollScope(
                    child: Builder(
                      builder: (BuildContext context) {
                        listController =
                            SheetPrimaryScrollScope.controllerOf(context);
                        return ListView.builder(
                          itemCount: 40,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 80,
                              child: Text('Item $index'),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.drag(find.text('Item 2'), const Offset(0, -240));
    await tester.pumpAndSettle();
    final double listOffset = listController!.offset;
    expect(listOffset, greaterThan(0));

    navigatorKey.currentState!.pushNamed('/detail');
    await tester.pumpAndSettle();

    expect(detailController, isNotNull);
    expect(detailController, isNot(same(listController)));
    expect(detailController!.offset, 0);

    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    expect(listController!.offset, listOffset);
  });
}

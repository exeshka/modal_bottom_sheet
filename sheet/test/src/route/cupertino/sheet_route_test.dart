import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';
import 'package:sheet/src/route/cupertino/sheet_route.dart';

import '../../../helpers.dart';

void main() {
  group('CupertinoSheetRoute', () {
    testWidgets('renders', (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());

      Navigator.of(tester.contextForRootNavigator).push(
        CupertinoSheetRoute(builder: (context) => Text('Sheet')),
      );
      await tester.pumpAndSettle();
      expect(findSheet(), findsOneWidget);
      expect(find.text('Sheet'), findsOneWidget);
    });

    testWidgets('animates previous route when using MaterialExtendedPageRoute',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());
      final controller = Navigator.of(tester.contextForRootNavigator);
      controller.push(
        MaterialExtendedPageRoute(builder: (context) => SizedBox()),
      );
      await tester.pumpAndSettle();
      controller.push(
        CupertinoSheetRoute(builder: (context) => Text('Sheet')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoSheetBottomRouteTransition), findsOneWidget);
    });

    testWidgets('animates previous route when using CupertinoExtendedPageRoute',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());
      final controller = Navigator.of(tester.contextForRootNavigator);
      controller.push(
        CupertinoExtendedPageRoute(builder: (context) => SizedBox()),
      );
      await tester.pumpAndSettle();
      controller.push(
        CupertinoSheetRoute(builder: (context) => Text('Sheet')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoSheetBottomRouteTransition), findsOneWidget);
    });
  });

  group('CupertinoSheetPage', () {
    testWidgets('passes sheet configuration to route',
        (WidgetTester tester) async {
      late BuildContext routeContext;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            routeContext = context;
            return const SizedBox();
          },
        ),
      ));

      final page = CupertinoSheetPage<void>(
        child: Text('Sheet'),
        initialStop: 0.5,
        stops: const <double>[0, 0.5, 1],
        fit: SheetFit.loose,
        draggable: false,
        backgroundColor: Colors.red,
        maintainState: false,
      );

      final route = page.createRoute(routeContext) as CupertinoSheetRoute<void>;

      expect(route.initialExtent, 0.5);
      expect(route.stops, const <double>[0, 0.5, 1]);
      expect(route.fit, SheetFit.loose);
      expect(route.draggable, isFalse);
      expect(route.maintainState, isFalse);
    });

    testWidgets('renders', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return Navigator(
            pages: [
              MaterialPage(child: SizedBox()),
              CupertinoSheetPage(child: Text('Sheet')),
            ],
            onDidRemovePage: (Page<dynamic> page) {},
          );
        },
      ));
      await tester.pumpAndSettle();
      expect(findSheet(), findsOneWidget);
      expect(find.text('Sheet'), findsOneWidget);
    });

    testWidgets('animates previous route when using MaterialExtendedPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return Navigator(
            pages: [
              MaterialExtendedPage(child: SizedBox()),
              CupertinoSheetPage(child: Text('Sheet')),
            ],
            onDidRemovePage: (Page<dynamic> page) {},
          );
        },
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoSheetBottomRouteTransition), findsOneWidget);
    });

    testWidgets('animates previous route when using CupertinoExtendedPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return Navigator(
            pages: [
              CupertinoExtendedPage(child: SizedBox()),
              CupertinoSheetPage(child: Text('Sheet')),
            ],
            onDidRemovePage: (Page<dynamic> page) {},
          );
        },
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoSheetBottomRouteTransition), findsOneWidget);
    });
  });
}

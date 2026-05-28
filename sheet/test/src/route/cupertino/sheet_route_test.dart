import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';
import 'package:sheet/src/route/cupertino/sheet_route.dart';

import '../../../helpers.dart';

void main() {
  group('CupertinoSheetRoute', () {
    testWidgets('uses a faster reverse transition',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());
      final CupertinoSheetRoute<void> route = CupertinoSheetRoute<void>(
        builder: (context) => Text('Sheet'),
      );

      Navigator.of(tester.contextForRootNavigator).push(route);
      await tester.pump();

      expect(route.transitionDuration, const Duration(milliseconds: 400));
      expect(route.reverseTransitionDuration,
          const Duration(microseconds: 235294));
    });

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

    testWidgets('stops navigator gesture when dismissed by drag',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());
      final NavigatorState navigator =
          Navigator.of(tester.contextForRootNavigator);

      navigator.push(
        CupertinoSheetRoute(builder: (context) => Text('Sheet')),
      );
      await tester.pumpAndSettle();

      await tester.drag(findSheet(), const Offset(0, 700));
      await tester.pumpAndSettle();

      expect(navigator.userGestureInProgress, isFalse);
      expect(find.text('Sheet'), findsNothing);
    });

    testWidgets('dismisses smoothly when barrier is tapped while opening',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());
      final NavigatorState navigator =
          Navigator.of(tester.contextForRootNavigator);

      final CupertinoSheetRoute<void> route = CupertinoSheetRoute<void>(
        initialStop: 0.8,
        builder: (context) => Text('Sheet'),
      );
      navigator.push(route);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final double openingValue = route.sheetController.animation.value;
      expect(openingValue, greaterThan(0));
      expect(openingValue, lessThan(0.8));

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(route.sheetController.animation.value, lessThan(openingValue));

      await tester.pumpAndSettle();
      expect(find.text('Sheet'), findsNothing);
    });

    testWidgets('finishes opening before another route is pushed',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());
      final NavigatorState navigator =
          Navigator.of(tester.contextForRootNavigator);

      final CupertinoSheetRoute<void> firstRoute = CupertinoSheetRoute<void>(
        initialStop: 0.8,
        builder: (context) => Text('First sheet'),
      );
      navigator.push(firstRoute);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(firstRoute.animation!.value, lessThan(1));
      expect(firstRoute.sheetController.animation.value, lessThan(0.8));

      navigator.push(
        CupertinoSheetRoute<void>(
          builder: (context) => Text('Second sheet'),
        ),
      );
      await tester.pump();

      expect(firstRoute.animation!.value, 1);
      expect(firstRoute.sheetController.animation.value, 0.8);
    });

    testWidgets('scrolls to the end when max stop is below full height',
        (WidgetTester tester) async {
      await tester.pumpApp(SizedBox());

      Navigator.of(tester.contextForRootNavigator).push(
        CupertinoSheetRoute<void>(
          initialStop: 0.5,
          stops: const <double>[0, 0.5],
          builder: (BuildContext context) {
            return Material(
              child: ListView.builder(
                controller: PrimaryScrollController.of(context),
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      for (var i = 0; i < 8; i += 1) {
        await tester.fling(
          find.byType(ListView),
          const Offset(0, -800),
          8000,
        );
        await tester.pumpAndSettle();
      }

      expect(find.text('Item 99'), findsOneWidget);
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

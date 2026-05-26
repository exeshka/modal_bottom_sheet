import 'package:flutter/cupertino.dart' hide CupertinoSheetRoute;
import 'package:flutter/material.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

import 'demos/sheet_fit.dart';
import 'demos/sheet_inside_sheet.dart';
import 'demos/sheet_navigator.dart';
import 'demos/sheet_pop_scope.dart';
import 'demos/sheet_scroll.dart';
import 'demos/sheet_snap_stops.dart';
import 'pages/declarative_sheet_page.dart';
import 'pages/go_router_sheet_page.dart';
import 'web_frame.dart';

void main() => runApp(const SheetExampleApp());

class SheetExampleApp extends StatelessWidget {
  const SheetExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CupertinoSheetRoute',
      theme: ThemeData(platform: TargetPlatform.iOS),
      darkTheme: ThemeData.dark().copyWith(platform: TargetPlatform.iOS),
      builder: (context, child) => WebFrame(
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Theme.of(context).brightness,
            scaffoldBackgroundColor: CupertinoColors.systemBackground,
          ),
          child: child!,
        ),
      ),
      home: const CupertinoSheetHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CupertinoSheetHomePage extends StatelessWidget {
  const CupertinoSheetHomePage({super.key});

  void _pushSheet(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    double initialStop = 1,
    List<double>? stops,
    SheetFit fit = SheetFit.expand,
    bool draggable = true,
  }) {
    Navigator.of(context).push<void>(
      CupertinoSheetRoute<void>(
        builder: builder,
        initialStop: initialStop,
        stops: stops,
        fit: fit,
        draggable: draggable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('CupertinoSheetRoute'),
        ),
        child: SafeArea(
          bottom: false,
          child: ListView(
            children: <Widget>[
              _section(context, 'Basics'),
              _tile(
                context,
                title: 'Full sheet (default)',
                subtitle: 'initialStop: 1, SheetFit.expand',
                onTap: () => _pushSheet(
                  context,
                  title: 'Full',
                  builder: (_) => const SheetScrollDemo(),
                ),
              ),
              _tile(
                context,
                title: 'Fit content (loose)',
                subtitle: 'SheetFit.loose — action sheet height',
                onTap: () => _pushSheet(
                  context,
                  title: 'Fit',
                  fit: SheetFit.loose,
                  builder: (_) => const SheetFitDemo(),
                ),
              ),
              _tile(
                context,
                title: 'Half height on open',
                subtitle: 'initialStop: 0.5',
                onTap: () => _pushSheet(
                  context,
                  title: 'Half',
                  initialStop: 0.5,
                  builder: (_) => const SheetScrollDemo(),
                ),
              ),
              _section(context, 'Dragging'),
              _tile(
                context,
                title: 'Snap stops',
                subtitle: 'stops: [0, 0.4, 1]',
                onTap: () => _pushSheet(
                  context,
                  title: 'Stops',
                  stops: const <double>[0, 0.4, 1],
                  builder: (_) => const SheetSnapStopsDemo(),
                ),
              ),
              _tile(
                context,
                title: 'Non-draggable',
                subtitle: 'draggable: false — tap barrier to dismiss',
                onTap: () => _pushSheet(
                  context,
                  title: 'Locked',
                  draggable: false,
                  builder: (_) => const SheetScrollDemo(),
                ),
              ),
              _section(context, 'Content'),
              _tile(
                context,
                title: 'Scrollable list',
                subtitle: 'PrimaryScrollController from sheet',
                onTap: () => _pushSheet(
                  context,
                  title: 'Scroll',
                  builder: (_) => const SheetScrollDemo(),
                ),
              ),
              _tile(
                context,
                title: 'Sheet inside sheet',
                subtitle: 'Nested CupertinoSheetRoute',
                onTap: () => _pushSheet(
                  context,
                  title: 'Nested',
                  builder: (_) => const SheetInsideSheetDemo(),
                ),
              ),
              _tile(
                context,
                title: 'Reverse list inside sheet',
                subtitle: 'ListView.reverse',
                onTap: () => _pushSheet(
                  context,
                  title: 'Reverse',
                  builder: (_) =>
                      const SheetInsideSheetDemo(reverse: true),
                ),
              ),
              _tile(
                context,
                title: 'Nested Navigator',
                subtitle: 'Push routes inside the sheet',
                onTap: () => _pushSheet(
                  context,
                  title: 'Navigator',
                  builder: (_) => const SheetNavigatorDemo(),
                ),
              ),
              _tile(
                context,
                title: 'PopScope confirm dismiss',
                subtitle: 'Blocks drag-to-dismiss until confirmed',
                onTap: () => _pushSheet(
                  context,
                  title: 'PopScope',
                  builder: (_) => const SheetPopScopeDemo(),
                ),
              ),
              _section(context, 'Routes & transitions'),
              _tile(
                context,
                title: 'iOS parallax (extended page)',
                subtitle:
                    'Push CupertinoExtendedPageRoute, then sheet — animates previous route',
                onTap: () {
                  Navigator.of(context).push<void>(
                    CupertinoExtendedPageRoute<void>(
                      builder: (_) => _ExtendedRoutePreview(
                        onOpenSheet: () {
                          Navigator.of(context).push<void>(
                            CupertinoSheetRoute<void>(
                              builder: (_) => const SheetFitDemo(),
                              fit: SheetFit.loose,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              _tile(
                context,
                title: 'Material extended + sheet',
                subtitle: 'MaterialExtendedPageRoute + CupertinoSheetRoute',
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialExtendedPageRoute<void>(
                      builder: (_) => _ExtendedRoutePreview(
                        label: 'Material extended',
                        onOpenSheet: () {
                          Navigator.of(context).push<void>(
                            CupertinoSheetRoute<void>(
                              builder: (_) => const SheetFitDemo(),
                              fit: SheetFit.loose,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              _tile(
                context,
                title: 'CupertinoSheetPage (Navigator 2.0)',
                subtitle: 'Declarative pages API',
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const DeclarativeSheetPageDemo(),
                  ),
                ),
              ),
              _section(context, 'go_router'),
              _tile(
                context,
                title: 'go_router — books + sheet',
                subtitle:
                    'MaterialExtendedPage + CupertinoSheetPage, context.go',
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const GoRouterSheetDemo(),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CupertinoListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const CupertinoListTileChevron(),
      onTap: onTap,
    );
  }
}

class _ExtendedRoutePreview extends StatelessWidget {
  const _ExtendedRoutePreview({
    required this.onOpenSheet,
    this.label = 'Extended route',
  });

  final VoidCallback onOpenSheet;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(label),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'This page uses an extended route so the sheet '
                  'can scale and round the route behind it.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: onOpenSheet,
                child: const Text('Open CupertinoSheetRoute'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

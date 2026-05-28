import 'package:flutter/cupertino.dart' hide CupertinoSheetRoute;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

import '../demos/sheet_fit.dart';
import '../demos/sheet_scroll.dart';
import '../demos/sheet_shell_routes.dart';
import '../web_frame.dart';

/// go_router + [CupertinoSheetPage] + [MaterialExtendedPage].
///
/// List route uses [MaterialExtendedPage] so the previous route animates
/// behind the sheet. Sheet routes use [CupertinoSheetPage] in [pageBuilder].
///
/// Inner navigation inside a sheet uses a single [GoRouter] with [ShellRoute]:
/// the shell is shown on the root navigator ([parentNavigatorKey]), and child
/// routes share the shell's [navigatorKey].
class GoRouterSheetDemo extends StatefulWidget {
  const GoRouterSheetDemo({super.key});

  @override
  State<GoRouterSheetDemo> createState() => _GoRouterSheetDemoState();
}

class _GoRouterSheetDemoState extends State<GoRouterSheetDemo> {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _sheetShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sheetShell');
  final GlobalKey<NavigatorState> _sheetStopsShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sheetStopsShell');

  final List<Book> _books = const <Book>[
    Book('1', 'Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('2', 'Foundation', 'Isaac Asimov'),
    Book('3', 'Fahrenheit 451', 'Ray Bradbury'),
  ];

  Brightness _brightness = Brightness.light;

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialExtendedPage<void>(
            key: state.pageKey,
            child: _BooksListScreen(
              books: _books,
              brightness: _brightness,
              onBrightnessChanged: (Brightness value) {
                setState(() => _brightness = value);
              },
            ),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: 'book',
            path: 'book/:bookId',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final Book book = _bookForId(state.pathParameters['bookId']!);
              return CupertinoSheetPage<void>(
                key: state.pageKey,
                child: _BookDetailsScreen(book: book),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: 'book-notes',
                path: 'notes',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final Book book = _bookForId(state.pathParameters['bookId']!);
                  return CupertinoSheetPage<void>(
                    key: state.pageKey,
                    child: _BookNotesSheet(book: book),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: 'sheet-fit',
            path: 'sheet-fit',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CupertinoSheetPage<void>(
                key: state.pageKey,
                fit: SheetFit.loose,
                child: const SheetFitDemo(),
              );
            },
          ),
          GoRoute(
            name: 'sheet-half',
            path: 'sheet-half',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CupertinoSheetPage<void>(
                key: state.pageKey,
                initialStop: 0.5,
                stops: [0, 0.5],
                child: const SheetScrollDemo(),
              );
            },
          ),
          GoRoute(
            name: 'sheet-stops',
            path: 'sheet-stops',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CupertinoSheetPage<void>(
                key: state.pageKey,
                stops: const <double>[0, 0.4, 0.6, 1],
                initialStop: 0.4,
                child: const SheetScrollDemo(),
              );
            },
          ),
          ShellRoute(
            parentNavigatorKey: _rootNavigatorKey,
            navigatorKey: _sheetShellNavigatorKey,
            pageBuilder:
                (BuildContext context, GoRouterState state, Widget child) {
              return CupertinoSheetPage<void>(
                key: state.pageKey,
                child: SheetPrimaryScrollScope(child: child),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: 'sheet-navigator',
                path: 'sheet-navigator',
                builder: (BuildContext context, GoRouterState state) {
                  return const SheetShellListPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: 'sheet-navigator-detail',
                    path: 'detail/:id',
                    builder: (BuildContext context, GoRouterState state) {
                      return SheetShellDetailPage(
                        id: state.pathParameters['id']!,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          ShellRoute(
            parentNavigatorKey: _rootNavigatorKey,
            navigatorKey: _sheetStopsShellNavigatorKey,
            pageBuilder:
                (BuildContext context, GoRouterState state, Widget child) {
              return CupertinoSheetPage<void>(
                key: state.pageKey,
                stops: const <double>[0, 0.4, 0.6, 1],
                initialStop: 0.4,
                child: SheetPrimaryScrollScope(child: child),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: 'sheet-stops-navigator',
                path: 'sheet-stops-navigator',
                builder: (BuildContext context, GoRouterState state) {
                  return const SheetShellListPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: 'sheet-stops-navigator-detail',
                    path: 'detail/:id',
                    builder: (BuildContext context, GoRouterState state) {
                      return SheetShellDetailPage(
                        id: state.pathParameters['id']!,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final String? bookId = state.pathParameters['bookId'];
      if (bookId != null && !_books.any((Book b) => b.id == bookId)) {
        return '/';
      }
      return null;
    },
  );

  Book _bookForId(String id) => _books.firstWhere((Book b) => b.id == id);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        brightness: _brightness,
      ),
      builder: (BuildContext context, Widget? child) {
        return WebFrame(
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: _brightness,
              scaffoldBackgroundColor: CupertinoColors.systemBackground,
            ),
            child: child!,
          ),
        );
      },
    );
  }
}

class Book {
  const Book(this.id, this.title, this.author);

  final String id;
  final String title;
  final String author;
}

class _BooksListScreen extends StatelessWidget {
  const _BooksListScreen({
    required this.books,
    required this.brightness,
    required this.onBrightnessChanged,
  });

  final List<Book> books;
  final Brightness brightness;
  final ValueChanged<Brightness> onBrightnessChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: const Text('go_router'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            onBrightnessChanged(
              brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
            );
          },
          child: Icon(
            brightness == Brightness.light
                ? CupertinoIcons.moon_fill
                : CupertinoIcons.sun_max_fill,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          children: <Widget>[
            const _SectionHeader('Books → sheet (CupertinoSheetPage)'),
            for (final Book book in books)
              CupertinoListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                trailing: const CupertinoListTileChevron(),
                onTap: () => context.go('/book/${book.id}'),
              ),
            const _SectionHeader('Direct sheet routes'),
            CupertinoListTile(
              title: const Text('Fit sheet'),
              subtitle: const Text('context.go(\'/sheet-fit\')'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.go('/sheet-fit'),
            ),
            CupertinoListTile(
              title: const Text('Half height sheet'),
              subtitle: const Text('initialStop: 0.5'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.go('/sheet-half'),
            ),
            CupertinoListTile(
              title: const Text('Snap stops sheet'),
              subtitle: const Text('stops: [0, 0.4, 1]'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.go('/sheet-stops'),
            ),
            const _SectionHeader('Sheet with inner navigation'),
            CupertinoListTile(
              title: const Text('ShellRoute (one GoRouter)'),
              subtitle: const Text(
                'ShellRoute + parentNavigatorKey — /sheet-navigator/detail/:id',
              ),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.go('/sheet-navigator'),
            ),
            CupertinoListTile(
              title: const Text('ShellRoute with Stops (one GoRouter)'),
              subtitle: const Text(
                'ShellRoute + custom stops [0, 0.4, 0.6, 1] — /sheet-stops-navigator/detail/:id',
              ),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.go('/sheet-stops-navigator'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BookDetailsScreen extends StatelessWidget {
  const _BookDetailsScreen({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(book.title),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => context.pop(),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: () => context.go('/book/${book.id}/notes'),
                  child: const Text('Open nested sheet (notes)'),
                ),
                const SizedBox(height: 12),
                CupertinoButton(
                  onPressed: () => context.pop(),
                  child: const Text('context.pop() — dismiss sheet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookNotesSheet extends StatelessWidget {
  const _BookNotesSheet({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Notes · ${book.title}'),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => context.pop(),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Nested [CupertinoSheetPage] on top of another sheet.\n'
              'Path: /book/${book.id}/notes',
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
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
}

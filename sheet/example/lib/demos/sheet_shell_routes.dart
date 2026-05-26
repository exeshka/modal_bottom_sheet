import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sheet/sheet.dart';

/// Root of the sheet branch: `/sheet-navigator` or `/sheet-stops-navigator`.
class SheetShellListPage extends StatelessWidget {
  const SheetShellListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final String basePrefix = location.split('/detail').first;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Sheet · ShellRoute'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => context.go('/'),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          controller: SheetPrimaryScrollScope.controllerOf(context),
          children: <Widget>[
            _LocationBanner(location: location),
            for (int i = 0; i < 20; i++)
              CupertinoListTile(
                title: Text('Detail $i'),
                subtitle: Text("context.go('$basePrefix/detail/$i')"),
                trailing: const CupertinoListTileChevron(),
                onTap: () => {
                  print(" context.go('$basePrefix/detail/$i')"),
                  context.go('$basePrefix/detail/$i')
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Nested under the sheet shell: `.../detail/:id`.
class SheetShellDetailPage extends StatelessWidget {
  const SheetShellDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final String basePrefix = location.split('/detail').first;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Detail $id'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => context.pop(),
        ),
      ),
      child: SafeArea(
        child: ListView(
          controller: SheetPrimaryScrollScope.controllerOf(context),
          children: <Widget>[
            _LocationBanner(location: location),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Same GoRouter, same ShellRoute.\n'
                'Only the inner navigator stack changes.',
              ),
            ),
            CupertinoButton.filled(
              onPressed: () => context.go('$basePrefix/detail/${id}_next'),
              child: Text("go → $basePrefix/detail/${id}_next"),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationBanner extends StatelessWidget {
  const _LocationBanner({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Location: $location',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

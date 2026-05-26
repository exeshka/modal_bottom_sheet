import 'package:flutter/widgets.dart';
import 'package:sheet/sheet.dart';

/// Re-exposes the [Sheet] scroll controller to descendants.
///
/// [Sheet] already installs a [PrimaryScrollController], but nested
/// [Navigator]s (for example a [ShellRoute] from go_router) can prevent
/// [PrimaryScrollController.of] from reaching scrollables inside route pages.
///
/// Wrap the shell [Navigator] (the `child` of a [ShellRoute.pageBuilder]) with
/// this widget when building a [CupertinoSheetPage].
class SheetPrimaryScrollScope extends StatelessWidget {
  const SheetPrimaryScrollScope({
    super.key,
    required this.child,
  });

  final Widget child;

  /// Returns the [ScrollController] driven by the enclosing [Sheet], if any.
  static ScrollController? maybeControllerOf(BuildContext context) {
    return SheetScrollable.of(context)?.position.scrollController;
  }

  /// Returns the [ScrollController] driven by the enclosing [Sheet].
  static ScrollController controllerOf(BuildContext context) {
    final ScrollController? controller = maybeControllerOf(context);
    assert(
      controller != null,
      'SheetPrimaryScrollScope.controllerOf must be called below a Sheet.',
    );
    return controller!;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController? controller = maybeControllerOf(context);
    if (controller == null) {
      return child;
    }
    return PrimaryScrollController(
      controller: controller,
      child: child,
    );
  }
}

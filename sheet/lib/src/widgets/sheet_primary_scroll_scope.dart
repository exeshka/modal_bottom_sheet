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
class SheetPrimaryScrollScope extends StatefulWidget {
  const SheetPrimaryScrollScope({
    super.key,
    required this.child,
  });

  final Widget child;

  /// Returns the [ScrollController] driven by the enclosing [Sheet], if any.
  static ScrollController? maybeControllerOf(BuildContext context) {
    final _SheetPrimaryScrollControllerScope? scope =
        context.dependOnInheritedWidgetOfExactType<
            _SheetPrimaryScrollControllerScope>();
    if (scope != null) {
      return scope.state.maybeControllerOf(context);
    }
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
  State<SheetPrimaryScrollScope> createState() =>
      _SheetPrimaryScrollScopeState();
}

class _SheetPrimaryScrollScopeState extends State<SheetPrimaryScrollScope> {
  final Map<ModalRoute<Object?>?, SheetPrimaryScrollController> _controllers =
      <ModalRoute<Object?>?, SheetPrimaryScrollController>{};

  SheetContext? _sheetContext;

  ScrollController? maybeControllerOf(BuildContext context) {
    final SheetState? sheet = SheetScrollable.of(context);
    if (sheet == null) {
      return null;
    }

    if (_sheetContext != sheet) {
      _disposeControllers();
      _sheetContext = sheet;
    }

    final ModalRoute<Object?>? route = ModalRoute.of(context);
    return _controllers.putIfAbsent(
      route,
      () => SheetPrimaryScrollController(sheetContext: sheet),
    );
  }

  void _disposeControllers() {
    for (final SheetPrimaryScrollController controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController? controller = maybeControllerOf(context);
    Widget child = widget.child;
    if (controller != null) {
      child = PrimaryScrollController(
        controller: controller,
        child: child,
      );
    }
    return _SheetPrimaryScrollControllerScope(
      state: this,
      child: child,
    );
  }
}

class _SheetPrimaryScrollControllerScope extends InheritedWidget {
  const _SheetPrimaryScrollControllerScope({
    required this.state,
    required super.child,
  });

  final _SheetPrimaryScrollScopeState state;

  @override
  bool updateShouldNotify(_SheetPrimaryScrollControllerScope oldWidget) {
    return state != oldWidget.state;
  }
}

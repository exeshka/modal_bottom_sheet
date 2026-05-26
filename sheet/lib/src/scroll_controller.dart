import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:sheet/sheet.dart';

/// A [ScrollController] suitable for use in a [SheetPrimaryScrollPosition] created
/// by a [Sheet].
///
/// If a [Sheet] contains content that is exceeds the height
/// of its container, this controller will allow the sheet to both be dragged to
/// fill the container and then scroll the child content.
///
/// See also:
///
///  * [SheetPrimaryScrollPosition], which manages the positioning logic for
///    this controller.
///  * [PrimarySheetController], which can be used to establish a
///    [_SheetScrollController] as the primary controller for
///    descendants.
class SheetPrimaryScrollController extends ScrollController {
  SheetPrimaryScrollController({
    super.initialScrollOffset,
    super.debugLabel,
    super.onAttach,
    super.onDetach,
    required this.sheetContext,
  });

  final SheetContext sheetContext;

  @override
  SheetPrimaryScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return SheetPrimaryScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      sheetContext: sheetContext,
    );
  }
}

class _SheetScrollActivity extends ScrollActivity {
  _SheetScrollActivity(SheetPosition super.delegate);

  @override
  bool get isScrolling => true;

  @override
  bool get shouldIgnorePointer => false;

  @override
  double get velocity => 0;
}

/// A scroll position that manages scroll activities for
/// [_SheetScrollController].
///
/// This class is a concrete subclass of [ScrollPosition] logic that handles a
/// single [ScrollContext], such as a [Scrollable]. An instance of this class
/// manages [ScrollActivity] instances, which changes the
/// [SheetPrimaryScrollPosition.currentExtent] or visible content offset in the
/// [Scrollable]'s [Viewport]
///
/// See also:
///
///  * [_SheetScrollController], which uses this as its [ScrollPosition].
class SheetPrimaryScrollPosition extends ScrollPositionWithSingleContext {
  SheetPrimaryScrollPosition({
    required super.physics,
    required super.context,
    double super.initialPixels,
    super.keepScrollOffset,
    required this.sheetContext,
    super.oldPosition,
    super.debugLabel,
  });

  final SheetContext sheetContext;
  SheetPosition get sheetPosition => sheetContext.position;

  bool sheetShouldSheetAcceptUserOffset(double delta) {
    // Can drag down if list already on the top
    final bool canDragForward = delta >= 0 && pixels <= minScrollExtent;

    // Find if SnapSheetPhysics is present in the sheet's physics chain to determine the effective max stop
    ScrollPhysics? currentPhysics = sheetPosition.physics;
    double maxStop = 1.0;
    while (currentPhysics != null) {
      if (currentPhysics is SnapSheetPhysics) {
        maxStop = currentPhysics.stops.reduce(math.max);
        break;
      }
      currentPhysics = currentPhysics.parent;
    }
    final double effectiveMaxScrollExtent = sheetPosition.hasContentDimensions
        ? maxStop * sheetPosition.maxScrollExtent
        : 0.0;

    // Can drag up if sheet is not yet on top and list is already on top
    final bool canDragBackwards = delta < 0 &&
        sheetPosition.pixels < effectiveMaxScrollExtent &&
        pixels <= minScrollExtent;

    return sheetPosition.physics.shouldAcceptUserOffset(sheetPosition) &&
        (canDragForward || canDragBackwards);
  }

  @override
  void applyUserOffset(double delta) {
    if (sheetPosition.preventingDrag) {
      return;
    }
    if (sheetShouldSheetAcceptUserOffset(delta)) {
      if (sheetPosition.activity is! _SheetScrollActivity) {
        sheetPosition.beginActivity(_SheetScrollActivity(sheetPosition));
      }
      final double sheetDelta =
          sheetPosition.physics.applyPhysicsToUserOffset(sheetPosition, delta);
      sheetPosition.applyUserOffset(sheetDelta);
      return;
    } else {
      // If we are dragging down to scroll the list back to top, and the drag
      // offset is larger than the distance to minScrollExtent, we can split
      // the delta: scroll the list exactly to top, and apply the remaining
      // delta to the outer sheet in the same frame!
      if (delta > 0 && pixels > minScrollExtent) {
        final double overflow = delta - (pixels - minScrollExtent);
        if (overflow > 0) {
          super.applyUserOffset(pixels - minScrollExtent);
          if (sheetPosition.activity is! _SheetScrollActivity) {
            sheetPosition.beginActivity(_SheetScrollActivity(sheetPosition));
          }
          final double sheetDelta = sheetPosition.physics
              .applyPhysicsToUserOffset(sheetPosition, overflow);
          sheetPosition.applyUserOffset(sheetDelta);
          return;
        }
      }
      super.applyUserOffset(delta);
      if (sheetPosition.activity is! HoldScrollActivity) {
        sheetPosition.hold(() {});
      }
    }
  }

  @override
  void goBallistic(double velocity) {
    if (sheetPosition.preventingDrag) {
      goIdle();
      return;
    }

    if (sheetPosition.hasContentDimensions) {
      if (sheetContext.initialAnimationFinished) {
        if ((activity is DragScrollActivity ||
                activity is HoldScrollActivity) &&
            sheetPosition.activity is _SheetScrollActivity) {
          sheetPosition.goBallistic(velocity);
        }
      } else {
        goIdle();
        return;
      }
    }

    ScrollPhysics? currentPhysics = sheetPosition.physics;
    double maxStop = 1.0;
    while (currentPhysics != null) {
      if (currentPhysics is SnapSheetPhysics) {
        maxStop = currentPhysics.stops.reduce(math.max);
        break;
      }
      currentPhysics = currentPhysics.parent;
    }
    final double effectiveMaxScrollExtent = sheetPosition.hasContentDimensions
        ? maxStop * sheetPosition.maxScrollExtent
        : 0.0;

    if (velocity > 0.0 && sheetPosition.pixels >= effectiveMaxScrollExtent ||
        (velocity < 0.0 && pixels > 0)) {
      super.goBallistic(velocity);
      return;
    } else if (outOfRange) {
      beginActivity(
        BallisticScrollActivity(
          this,
          ScrollSpringSimulation(
            SpringDescription.withDampingRatio(
              mass: 0.5,
              stiffness: 100.0,
              ratio: 1.1,
            ),
            pixels,
            0,
            velocity,
          ),
          context.vsync,
          true,
        ),
      );
      return;
    } else {
      goIdle();
      return;
    }
  }
}

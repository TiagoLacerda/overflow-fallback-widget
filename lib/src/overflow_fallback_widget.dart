import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum OverflowFallbackSlot { child, fallback }

/// A Widget that attempts to layout it's child with unbounded constraints then,
/// if the child's desired size exceeds the parent's constraints, lays out an
/// ideally smaller fallback child instead.
///
/// If [fallback] is null, simply lays out [child] with the incoming
/// constraints.
///
/// Otherwise, lays out [child] with unbounded constraints and checks whether
/// it's desired size exceeds the incoming constraints. If so, lays out
/// [fallback] instead, otherwise, lays out [child] again but this time with the
/// incoming constraints.
///
/// This two-pass layout therefore makes this a relatively expensive Widget, to
/// be used ideally for small collections of shallow widgets (such as actions
/// collapsing into a menu icon button).
class OverflowFallbackWidget
    extends
        SlottedMultiChildRenderObjectWidget<OverflowFallbackSlot, RenderBox> {
  /// The main child Widget.
  final Widget? child;

  /// The fallback Widget.
  final Widget? fallback;

  OverflowFallbackWidget({
    super.key,
    this.child,
    Widget? fallback,
  }) : fallback = fallback == null
           ? null
           : _FallbackParentDataWidget(child: fallback);

  @override
  Iterable<OverflowFallbackSlot> get slots => OverflowFallbackSlot.values;

  @override
  Widget? childForSlot(OverflowFallbackSlot slot) {
    return switch (slot) {
      OverflowFallbackSlot.child => child,
      OverflowFallbackSlot.fallback => fallback,
    };
  }

  @override
  SlottedContainerRenderObjectMixin<OverflowFallbackSlot, RenderBox>
  createRenderObject(
    BuildContext context,
  ) {
    return _OverflowFallbackWidgetRenderObject();
  }
}

class _FallbackParentDataWidget
    extends ParentDataWidget<_OverflowFallbackWidgetParentData> {
  const _FallbackParentDataWidget({required super.child});

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData =
        renderObject.parentData as _OverflowFallbackWidgetParentData;

    if (!parentData.isFallback) {
      parentData.isFallback = true;
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass =>
      _OverflowFallbackWidgetRenderObject;
}

class _OverflowFallbackWidgetParentData
    extends ContainerBoxParentData<RenderBox> {
  bool isFallback = false;
}

class _OverflowFallbackWidgetRenderObject extends RenderBox
    with
        SlottedContainerRenderObjectMixin<OverflowFallbackSlot, RenderBox>,
        DebugOverflowIndicatorMixin {
  RenderBox? get child => childForSlot(OverflowFallbackSlot.child);
  RenderBox? get fallback => childForSlot(OverflowFallbackSlot.fallback);

  bool isShowingFallback = false;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverflowFallbackWidgetParentData) {
      child.parentData = _OverflowFallbackWidgetParentData();
    }
  }

  @override
  void performLayout() {
    if (child == null) return;

    if (fallback == null) {
      // One-pass
      isShowingFallback = false;
      child!.layout(constraints);
      size = child!.size;
    } else {
      // Two-pass
      child!.layout(const BoxConstraints(), parentUsesSize: true);

      if (fallback != null && child!.size.width > constraints.maxWidth ||
          child!.size.height > constraints.maxHeight) {
        isShowingFallback = true;
        fallback!.layout(constraints, parentUsesSize: true);
        size = fallback!.size;
      } else {
        isShowingFallback = false;
        child!.layout(constraints, parentUsesSize: true);
        size = child!.size;
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isShowingFallback) {
      context.paintChild(
        fallback!,
        (fallback!.parentData as BoxParentData).offset + offset,
      );
    } else if (child != null) {
      context.paintChild(
        child!,
        (child!.parentData as BoxParentData).offset + offset,
      );
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (isShowingFallback && fallback != null) {
      return result.addWithPaintOffset(
        offset: (fallback!.parentData as BoxParentData).offset,
        position: position,
        hitTest: (result, transformed) => fallback!.hitTest(
          result,
          position: transformed,
        ),
      );
    } else if (child != null) {
      return result.addWithPaintOffset(
        offset: (child!.parentData as BoxParentData).offset,
        position: position,
        hitTest: (result, transformed) => child!.hitTest(
          result,
          position: transformed,
        ),
      );
    }
    return false;
  }
}

# overflow_fallback_widget

A widget that automatically switches to a fallback when its primary child overflows constraints.

Useful for cases like action rows collapsing into a menu button, or any layout where you want a graceful degradation when space is constrained, without relying on pre-defined breakpoints.

## Usage

A typical app bar pattern where actions collapse into a fallback overflow button:

```Dart
OverflowFallbackWidget(
    child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
            TextButton(
                onPressed: () {},
                child: Text('Home'),
            ),
            TextButton(
                onPressed: () {},
                child: Text('About'),
            ),
            TextButton(
                onPressed: () {},
                child: Text('Contact'),
            ),
        ],
    ),
    fallback: IconButton(
        onPressed: () {},
        icon: Icon(
            Icons.more_vert_rounded,
        ),
    ),
),
```


```Dart
import 'package:flutter/material.dart';
import 'package:overflow_fallback_widget/src/overflow_fallback_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: OverflowFallbackWidget(
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
        ),
      ),
    );
  }
}
```
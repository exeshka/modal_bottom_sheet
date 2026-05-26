import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// On web desktop, wraps the app in an iPhone-sized preview frame.
class WebFrame extends StatelessWidget {
  const WebFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.sizeOf(context).width > 600) {
      const mediaQuery = MediaQueryData(
        size: Size(414, 896),
        padding: EdgeInsets.only(top: 44, bottom: 34),
        devicePixelRatio: 2,
      );
      return Material(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: MediaQuery(
                data: mediaQuery,
                child: SizedBox(
                  width: mediaQuery.size.width,
                  height: mediaQuery.size.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return child;
  }
}

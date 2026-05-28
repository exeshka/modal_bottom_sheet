import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetScrollDemo extends StatelessWidget {
  const SheetScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        leading: null,
        border: null,
        automaticBackgroundVisibility: false,
        automaticallyImplyLeading: false,
        middle: Text('Sheet Scroll Demo'),
      ),

      // appBar: AppBar(
      //   title: Text('Sheet Scroll Demo'),
      // ),
      body: SafeArea(
        bottom: false,
        child: ListView.builder(
          controller: PrimaryScrollController.of(context),
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(title: Text('Item $index'));
          },
        ),
      ),
    );
  }
}

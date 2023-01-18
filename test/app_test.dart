import 'package:flutter/material.dart';
import 'package:flutter_counter/app.dart';
import 'package:flutter_counter/posts/views/post_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "InfiniteListApp",
    () {
      testWidgets(
        "is a MaterialApp",
        (widgetTester) async {
          expect(const InfiniteListApp(), isA<MaterialApp>());
        },
      );

      testWidgets(
        "home is PostPage",
        (widgetTester) async {
          expect(const InfiniteListApp().home, isA<PostPage>());
        },
      );

      testWidgets(
        "renders PostPage",
        (widgetTester) async {
          await widgetTester.pumpWidget(const InfiniteListApp());
          await widgetTester.pumpAndSettle();
          expect(find.byType(PostPage), findsOneWidget);
        },
      );
    },
  );
}

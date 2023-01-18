import 'package:flutter/material.dart';
import 'package:flutter_counter/posts/posts.dart';
import 'package:flutter_counter/posts/views/post_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "PostPage",
    () {
      testWidgets(
        "renders PostList",
        (widgetTester) async {
          await widgetTester.pumpWidget(
            const MaterialApp(
              home: PostPage(),
            ),
          );
          await widgetTester.pumpAndSettle();
          expect(find.byType(PostView), findsOneWidget);
        },
      );
    },
  );
}

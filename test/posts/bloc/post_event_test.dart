import 'package:flutter_counter/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "PostEvent",
    () {
      group(
        "PostFetched",
        () {
          testWidgets(
            "is a PostEvent",
            (widgetTester) async {
              expect(PostFetched(), isA<PostEvent>());
            },
          );
          testWidgets(
            "supports value comparision",
            (widgetTester) async {
              expect(PostFetched(), PostFetched());
            },
          );
        },
      );
    },
  );
}

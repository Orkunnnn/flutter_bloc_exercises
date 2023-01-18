import 'package:flutter_counter/posts/models/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "Post",
    () {
      test(
        "supports value comparasion",
        () {
          expect(
            const Post(id: 1, title: "post title", body: "post body"),
            const Post(id: 1, title: "post title", body: "post body"),
          );
        },
      );
    },
  );
}

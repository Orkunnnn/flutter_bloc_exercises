import 'package:flutter_counter/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "PostState",
    () {
      testWidgets(
        "overrides toString",
        (widgetTester) async {
          const state = PostState();
          expect(
            state.toString(),
            '''PostState { status: ${state.status}, hasReachedMax: ${state.hasReachedMax}, posts: ${state.posts.length} }''',
          );
        },
      );

      testWidgets(
        "is comparing objects by their values",
        (widgetTester) async {
          const currentState = PostState(status: PostStatus.success);
          final nextState = currentState.copyWith();
          expect(currentState == nextState, true);
        },
      );
    },
  );
}

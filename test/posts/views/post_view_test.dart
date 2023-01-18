import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/posts/models/post.dart';
import 'package:flutter_counter/posts/posts.dart';
import 'package:flutter_counter/posts/widgets/bottom_loader.dart';
import 'package:flutter_counter/posts/widgets/post_list_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}

extension on WidgetTester {
  Future<void> pumpPostsList(PostBloc postBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: postBloc,
          child: const PostView(),
        ),
      ),
    );
  }
}

void main() {
  final mockPosts = List.generate(
    5,
    (index) => Post(
      id: index,
      title: "post title",
      body: "post body",
    ),
  );

  late PostBloc postBloc;

  setUp(
    () {
      postBloc = MockPostBloc();
    },
  );
  group(
    "PostView",
    () {
      testWidgets(
        '''renders CircularProgressIndicator when post status is PostStatus.Initial''',
        (widgetTester) async {
          when(
            () => postBloc.state,
          ).thenReturn(const PostState());
          await widgetTester.pumpPostsList(postBloc);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
      testWidgets(
        '''renders no posts text when post status is success but with 0 posts''',
        (widgetTester) async {
          when(
            () => postBloc.state,
          ).thenReturn(
            const PostState(status: PostStatus.success, hasReachedMax: true),
          );
          await widgetTester.pumpPostsList(postBloc);
          expect(find.text("No Posts"), findsOneWidget);
        },
      );
      testWidgets(
        '''renders 5 posts and a bottom loader when post max is not reached yet''',
        (widgetTester) async {
          when(
            () => postBloc.state,
          ).thenReturn(PostState(status: PostStatus.success, posts: mockPosts));
          await widgetTester.pumpPostsList(postBloc);
          expect(find.byType(PostListItem), findsNWidgets(5));
          expect(find.byType(BottomLoader), findsOneWidget);
        },
      );
      testWidgets(
        '''does not renders BottomLoader when max post amount is reached''',
        (widgetTester) async {
          when(
            () => postBloc.state,
          ).thenReturn(
            PostState(
              status: PostStatus.success,
              hasReachedMax: true,
              posts: mockPosts,
            ),
          );
          await widgetTester.pumpPostsList(postBloc);
          expect(find.byType(BottomLoader), findsNothing);
        },
      );
      testWidgets(
        "fetches more posts when scrolled to bottom",
        (widgetTester) async {
          when(
            () => postBloc.state,
          ).thenReturn(
            PostState(
              status: PostStatus.success,
              posts: List.generate(
                10,
                (index) => Post(
                  id: index,
                  title: "post title",
                  body: "post body",
                ),
              ),
            ),
          );
          await widgetTester.pumpPostsList(postBloc);
          await widgetTester.drag(find.byType(PostView), const Offset(0, -500));
          verify(
            () => postBloc.add(PostFetched()),
          ).called(1);
        },
      );
    },
  );
}

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_counter/posts/models/post.dart';
import 'package:flutter_counter/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:http/http.dart" as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

Uri _postsUrl({required int startIndex}) {
  return Uri.https(
    "jsonplaceholder.typicode.com",
    "/posts",
    {"_start": "$startIndex", "_limit": "28"},
  );
}

void main() {
  group(
    "PostBloc",
    () {
      const mockPosts = [Post(id: 1, title: "post title", body: "post body")];
      late http.Client httpClient;

      setUp(
        () {
          httpClient = MockClient();
        },
      );

      setUpAll(
        () {
          registerFallbackValue(Uri());
        },
      );

      test(
        '''initial state is status: PostStatus.Initial, hasReachedMax: false, posts: []''',
        () {
          expect(PostBloc(httpClient: httpClient).state, const PostState());
        },
      );

      group(
        "PostFetched",
        () {
          blocTest<PostBloc, PostState>(
            "emits nothing when posts has reached maximum amount",
            build: () => PostBloc(httpClient: httpClient),
            seed: () => const PostState(hasReachedMax: true),
            act: (bloc) => bloc.add(PostFetched()),
            expect: () => <PostState>[],
          );
          blocTest<PostBloc, PostState>(
            "emits successful status when http fetches initial posts",
            setUp: () {
              when(
                () => httpClient.get(any()),
              ).thenAnswer(
                (_) async {
                  return http.Response(
                    '[{ "id": 1, "title": "post title", "body": "post body" }]',
                    HttpStatus.ok,
                  );
                },
              );
            },
            build: () => PostBloc(httpClient: httpClient),
            act: (bloc) => bloc.add(PostFetched()),
            expect: () => <PostState>[
              const PostState(status: PostStatus.success, posts: mockPosts)
            ],
            verify: (_) {
              verify(
                () => httpClient.get(_postsUrl(startIndex: 0)),
              ).called(1);
            },
          );
        },
      );
    },
  );
}

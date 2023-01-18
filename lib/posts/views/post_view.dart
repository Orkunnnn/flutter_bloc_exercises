import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/posts/bloc/post_bloc.dart';
import 'package:flutter_counter/posts/widgets/bottom_loader.dart';
import 'package:flutter_counter/posts/widgets/post_list_item.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.initial:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(
                child: Text("No Posts"),
              );
            }
            return ListView.builder(
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              controller: _scrollController,
              itemBuilder: (context, index) => index >= state.posts.length
                  ? const BottomLoader()
                  : PostListItem(post: state.posts[index]),
            );
          case PostStatus.failure:
            return const Center(
              child: Text("Failed to fetch posts"),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

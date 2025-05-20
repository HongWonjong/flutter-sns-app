import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/icon_button.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/post_card.dart';
import 'package:flutter_sns_app/presentation/providers/post_provider.dart';


class PostListPage extends ConsumerStatefulWidget {
  const PostListPage({super.key});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends ConsumerState<PostListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore) {
        _loadPosts();
      }
    });
  }

  Future<void> _loadPosts() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
      _errorMessage = null;
    });
    try {
      await ref.read(postProvider.notifier).fetchPosts();
    } catch (e) {
      setState(() {
        _errorMessage = '게시물 로드 실패: $e';
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - appBarHeight - statusBarHeight - 32;
    final cardHeight = availableHeight / 2.5;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (_errorMessage != null)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: AppStyles.pagePadding,
                        child: Column(
                          children: [
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _loadPosts,
                              child: const Text('재시도'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (posts.isEmpty && !_isLoadingMore && _errorMessage == null)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Text('게시물이 없습니다.'),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index < posts.length) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: PostCard(
                                post: posts[index],
                                cardHeight: cardHeight,
                              ),
                            ),
                            if (index < posts.length - 1)
                              Divider(
                                height: 1,
                                thickness: AppStyles.dividerThickness,
                                color: AppStyles.dividerColor,
                              ),
                          ],
                        );
                      }
                      return null;
                    },
                    childCount: posts.length,
                  ),
                ),
                if (_isLoadingMore)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: AppStyles.pagePadding,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                children: [
                  CustomIconButton(
                    icon: Icons.search,
                    onPressed: () {
                      // TODO: 검색 기능 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('검색 기능 준비 중')),
                      );
                    },
                    tooltip: '검색',
                  ),
                  const SizedBox(height: 12),
                  CustomIconButton(
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.pushNamed(context, '/post_create');
                    },
                    tooltip: '게시물 작성',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
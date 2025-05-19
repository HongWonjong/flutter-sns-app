// lib/presentation/pages/post_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';
import 'package:flutter_sns_app/presentation/providers/post_provider.dart';
import 'package:flutter_sns_app/presentation/widgets/post_card.dart';

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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppStyles.pagePadding,
                    child: Text(
                      '#오늘의 식단',
                      style: AppStyles.titleStyle,
                    ),
                  ),
                ),
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: PostCard(
                            post: posts[index],
                            cardHeight: cardHeight,
                          ),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: AppStyles.iconSizeLarge,
                      color: AppStyles.iconColor,
                    ),
                    onPressed: () {},
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/post_create');
                      },
                      child: Container(
                        padding: AppStyles.iconPadding,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppStyles.defaultShadow,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: AppStyles.iconSizeSmall,
                          color: AppStyles.accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
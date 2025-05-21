import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/end_of_posts_message.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/icon_button.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/post_card.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/search_dialog.dart';
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
  bool _isSearchingByTag = false;
  String? _currentTag;

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
      if (_isSearchingByTag && _currentTag != null) {
        await ref.read(postProvider.notifier).searchPostsByTag(_currentTag!);
      } else {
        await ref.read(postProvider.notifier).fetchPosts();
      }
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

  Future<void> _searchPostsByTag(String tag) async {
    setState(() {
      _isLoadingMore = true;
      _errorMessage = null;
      _isSearchingByTag = true;
      _currentTag = tag;
    });
    try {
      ref.read(postProvider.notifier).state = [];
      await ref.read(postProvider.notifier).searchPostsByTag(tag);
    } catch (e) {
      setState(() {
        _errorMessage = '태그 검색 실패: $e';
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _cancelSearch() async {
    setState(() {
      _isLoadingMore = true;
      _errorMessage = null;
      _isSearchingByTag = false;
      _currentTag = null;
    });
    try {
      await ref.read(postProvider.notifier).resetSearch();
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

  Future<void> _showSearchDialog(BuildContext context) async {
    final tag = await showDialog<String>(
      context: context,
      builder: (context) => const SearchDialog(),
    );
    if (tag != null) {
      _searchPostsByTag(tag);
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
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppStyles.listBackgroundGradientStart,
                AppStyles.listBackgroundGradientEnd,
              ],
            ),
          ),
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
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(_isSearchingByTag ? '검색 결과가 없습니다.' : '게시물이 없습니다.'),
                      ),
                    ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index < posts.length) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppStyles.pagePadding.left,
                                  vertical: AppStyles.cardSpacing,
                                ),
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: AppStyles.cardAnimationDuration,
                                  curve: AppStyles.animationCurve,
                                  child: PostCard(
                                    post: posts[index],
                                    cardHeight: cardHeight,
                                    onTagTap: _searchPostsByTag,
                                  ),
                                ),
                              ),
                              if (index < posts.length - 1)
                                Container(
                                  height: AppStyles.dividerThickness,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: AppStyles.pagePadding.left,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppStyles.dividerGradientStart,
                                        AppStyles.dividerGradientEnd,
                                      ],
                                    ),
                                    boxShadow: AppStyles.dividerShadow,
                                  ),
                                ),
                            ],
                          );
                        }
                        return null;
                      },
                      childCount: posts.length,
                    ),
                  ),
                  if (posts.isNotEmpty && !_isLoadingMore && _errorMessage == null)
                    const SliverToBoxAdapter(
                      child: EndOfPostsMessage(),
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
                        if (_isSearchingByTag) {
                          _cancelSearch();
                        } else {
                          _showSearchDialog(context);
                        }
                      },
                      tooltip: _isSearchingByTag ? '검색 취소' : '검색',
                      backgroundColor: _isSearchingByTag ? AppStyles.searchActiveBackgroundColor : null,
                      isLarge: true, iconColor: null,
                    ),
                    const SizedBox(height: 12),
                    CustomIconButton(
                      icon: Icons.edit,
                      onPressed: () {
                        Navigator.pushNamed(context, '/post_create');
                      },
                      tooltip: '게시물 작성',
                      isLarge: true, iconColor: null,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/news_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'dart:async';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../../../core/connectivity/connectivity_state.dart';
import '../../../../routes/route_names.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 300) {
        context.read<NewsBloc>().add(LoadMoreNews());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 👇 Extracted reusable ListView builder
  Widget _buildArticleList({
    required List articles,
    bool hasReachedMax = true,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsBloc>().add(RefreshNews());
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: hasReachedMax ? articles.length : articles.length + 1,
        itemBuilder: (context, index) {
          if (index >= articles.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final article = articles[index];

          return NewsCard(
            article: article,
            onTap: () {
              context.push(RouteNames.newsDetail, extra: article);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search news...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (value.trim().isEmpty) {
                    context.read<NewsBloc>().add(FetchTopHeadlines());
                  } else {
                    context.read<NewsBloc>().add(SearchNews(value.trim()));
                  }
                });
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            print('CURRENT STATE: ${state.runtimeType}'); // 👈 add this
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NewsLoaded) {
              if (state.articles.isEmpty) {
                return const Center(child: Text('No articles found'));
              }

              return _buildArticleList(
                articles: state.articles,
                hasReachedMax: state.hasReachedMax,
              );
            }

            if (state is NewsError) {
              // 👇 If cache exists, show it with an offline banner
              if (state.cachedArticles != null &&
                  state.cachedArticles!.isNotEmpty) {
                return Column(
                  children: [
                    BlocBuilder<ConnectivityCubit, ConnectivityState>(
                      builder: (context, connectivityState) {
                        if (connectivityState is ConnectivityOffline) {
                          return Container(
                            width: double.infinity,
                            color: Colors.red.shade100,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.wifi_off,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'No internet — showing cached news',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Expanded(
                      child: _buildArticleList(
                        articles: state.cachedArticles!,
                        hasReachedMax: true,
                      ),
                    ),
                  ],
                );
              }

              // 👇 No cache — show connectivity-aware error
              return BlocBuilder<ConnectivityCubit, ConnectivityState>(
                builder: (context, connectivityState) {
                  if (connectivityState is ConnectivityOffline) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No Internet Connection'),
                        ],
                      ),
                    );
                  }

                  return Center(child: Text(state.message));
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

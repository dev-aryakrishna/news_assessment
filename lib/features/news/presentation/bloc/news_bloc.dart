import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;

  int currentPage = 1;
  bool hasReachedMax = false;

  NewsBloc({
    required this.newsRepository,
  }) : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
    on<RefreshNews>(_onRefreshNews);
    on<SearchNews>(_onSearchNews);
    on<LoadMoreNews>(_onLoadMoreNews);
  }

  Future<void> _onFetchTopHeadlines(
    FetchTopHeadlines event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    try {
      currentPage = 1;

      final articles = await newsRepository.getTopHeadlines(
        page: currentPage,
      );

      emit(
        NewsLoaded(
          articles: articles,
          hasReachedMax: articles.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        NewsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    add(
      FetchTopHeadlines(),
    );
  }

  Future<void> _onSearchNews(
    SearchNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    try {
      currentPage = 1;

      final articles = await newsRepository.searchNews(
        query: event.query,
        page: currentPage,
      );

      emit(
        NewsLoaded(
          articles: articles,
          hasReachedMax: articles.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        NewsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNews event,
    Emitter<NewsState> emit,
  ) async {
    if (state is! NewsLoaded) return;

    final currentState = state as NewsLoaded;

    if (currentState.hasReachedMax) return;

    try {
      currentPage++;

      final articles = await newsRepository.getTopHeadlines(
        page: currentPage,
      );

      emit(
        NewsLoaded(
          articles: [
            ...currentState.articles,
            ...articles,
          ],
          hasReachedMax: articles.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        NewsError(
          e.toString(),
        ),
      );
    }
  }
}
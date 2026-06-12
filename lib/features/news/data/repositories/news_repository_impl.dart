import '../../domain/entities/news_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasource/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsEntity>> getTopHeadlines({required int page}) async {
    final articles = await remoteDataSource.getTopHeadlines(page: page);
    return articles.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<NewsEntity>> searchNews({
    required String query,
    required int page,
  }) async {
    final articles = await remoteDataSource.searchNews(
      query: query,
      page: page,
    );
    return articles.map((e) => e.toEntity()).toList();
  }
}

import '../../../../core/models/pagination_meta.dart';
import '../datasources/blog_remote_datasource.dart';
import '../models/post_model.dart';

class BlogRepository {
  final BlogRemoteDatasource _remoteDatasource;

  BlogRepository(this._remoteDatasource);

  Future<({List<PostModel> data, PaginationMeta meta})> getPosts({
    int page = 1,
  }) {
    return _remoteDatasource.getPosts(page: page);
  }

  Future<PostModel> getPost(int id) {
    return _remoteDatasource.getPost(id);
  }
}

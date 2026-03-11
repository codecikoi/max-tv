import '../../../../core/models/pagination_meta.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_model.dart';

class BlogRemoteDatasource {
  final DioClient _dioClient;

  BlogRemoteDatasource(this._dioClient);

  Future<({List<PostModel> data, PaginationMeta meta})> getPosts({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dioClient.dio.get('/blog/posts', queryParameters: {
      'current_page': page,
      'per_page': perPage,
    });
    final List data = response.data['data'] as List;
    final meta = PaginationMeta.fromJson(response.data['meta'] as Map<String, dynamic>);
    return (
      data: data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList(),
      meta: meta,
    );
  }

  Future<PostModel> getPost(int id) async {
    final response = await _dioClient.dio.get('/blog/post/$id');
    final List data = response.data['data'] as List;
    return PostModel.fromJson(data.first as Map<String, dynamic>);
  }
}

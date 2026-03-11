import '../../../../core/models/pagination_meta.dart';
import '../../../../core/network/dio_client.dart';
import '../models/channel_model.dart';
import '../models/category_model.dart';

class ChannelsRemoteDatasource {
  final DioClient _dioClient;

  ChannelsRemoteDatasource(this._dioClient);

  Future<({List<ChannelModel> data, PaginationMeta meta})> getChannels({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    final response = await _dioClient.dio.get('/channels', queryParameters: {
      'current_page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    final List data = response.data['data'] as List;
    final meta = PaginationMeta.fromJson(response.data['meta'] as Map<String, dynamic>);
    return (
      data: data.map((json) => ChannelModel.fromJson(json as Map<String, dynamic>)).toList(),
      meta: meta,
    );
  }

  Future<ChannelModel> getChannel(int id, {String? include}) async {
    final response = await _dioClient.dio.get('/channels/$id', queryParameters: {
      if (include != null) 'include': include,
    });
    return ChannelModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<({List<CategoryModel> data, PaginationMeta meta})> getCategories({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dioClient.dio.get('/categories', queryParameters: {
      'current_page': page,
      'per_page': perPage,
    });
    final List data = response.data['data'] as List;
    final meta = PaginationMeta.fromJson(response.data['meta'] as Map<String, dynamic>);
    return (
      data: data.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList(),
      meta: meta,
    );
  }

  Future<CategoryModel> getCategory(int id) async {
    final response = await _dioClient.dio.get('/categories/$id');
    return CategoryModel.fromJson(response.data as Map<String, dynamic>);
  }
}

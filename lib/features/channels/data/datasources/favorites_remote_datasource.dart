import '../../../../core/models/pagination_meta.dart';
import '../../../../core/network/dio_client.dart';
import '../models/channel_model.dart';

class FavoritesRemoteDatasource {
  final DioClient _dioClient;

  FavoritesRemoteDatasource(this._dioClient);

  Future<({List<ChannelModel> data, PaginationMeta meta})> getFavorites({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dioClient.dio.get('/favorites/channels', queryParameters: {
      'current_page': page,
      'per_page': perPage,
    });
    final List data = response.data['data'] as List;
    final meta = PaginationMeta.fromJson(response.data['meta'] as Map<String, dynamic>);
    return (
      data: data.map((json) => ChannelModel.fromJson(json as Map<String, dynamic>)).toList(),
      meta: meta,
    );
  }

  Future<void> addFavorite(int channelId) async {
    await _dioClient.dio.post('/favorites/channels/$channelId');
  }

  Future<void> removeFavorite(int channelId) async {
    await _dioClient.dio.delete('/favorites/channels/$channelId');
  }
}

import '../../../../core/network/dio_client.dart';

class PlaylistRemoteDatasource {
  final DioClient _dioClient;

  PlaylistRemoteDatasource(this._dioClient);

  Future<String> getPlaylistLink() async {
    final response = await _dioClient.dio.get('/playlist/link');
    return response.data['link'] as String;
  }

  Future<String> validateToken(String apiToken) async {
    final response = await _dioClient.dio.get('/playlist/$apiToken');
    return response.data['api_player_token'] as String;
  }
}

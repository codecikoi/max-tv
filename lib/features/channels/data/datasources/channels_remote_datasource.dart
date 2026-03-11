import '../../../../core/network/dio_client.dart';
import '../models/channel_model.dart';

class ChannelsRemoteDatasource {
  final DioClient _dioClient;

  ChannelsRemoteDatasource(this._dioClient);

  Future<List<ChannelModel>> getChannels() async {
    final response = await _dioClient.dio.get('/channels');
    final List data = response.data['data'];
    return data.map((json) => ChannelModel.fromJson(json)).toList();
  }

  Future<List<ChannelModel>> searchChannels(String query) async {
    final response = await _dioClient.dio.get('/channels/search', queryParameters: {'q': query});
    final List data = response.data['data'];
    return data.map((json) => ChannelModel.fromJson(json)).toList();
  }
}

import '../datasources/channels_remote_datasource.dart';
import '../models/channel_model.dart';

class ChannelsRepository {
  final ChannelsRemoteDatasource _remoteDatasource;

  ChannelsRepository(this._remoteDatasource);

  Future<List<ChannelModel>> getChannels() {
    return _remoteDatasource.getChannels();
  }

  Future<List<ChannelModel>> searchChannels(String query) {
    return _remoteDatasource.searchChannels(query);
  }
}

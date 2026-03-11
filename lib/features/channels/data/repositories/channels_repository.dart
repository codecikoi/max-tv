import '../../../../core/models/pagination_meta.dart';
import '../datasources/channels_remote_datasource.dart';
import '../models/channel_model.dart';
import '../models/category_model.dart';

class ChannelsRepository {
  final ChannelsRemoteDatasource _remoteDatasource;

  ChannelsRepository(this._remoteDatasource);

  Future<({List<ChannelModel> data, PaginationMeta meta})> getChannels({
    int page = 1,
    String? search,
  }) {
    return _remoteDatasource.getChannels(page: page, search: search);
  }

  Future<ChannelModel> getChannel(int id, {String? include}) {
    return _remoteDatasource.getChannel(id, include: include);
  }

  Future<({List<CategoryModel> data, PaginationMeta meta})> getCategories({
    int page = 1,
  }) {
    return _remoteDatasource.getCategories(page: page);
  }

  Future<CategoryModel> getCategory(int id) {
    return _remoteDatasource.getCategory(id);
  }
}

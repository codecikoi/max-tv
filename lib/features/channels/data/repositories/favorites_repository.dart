import '../../../../core/models/pagination_meta.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../models/channel_model.dart';

class FavoritesRepository {
  final FavoritesRemoteDatasource _remoteDatasource;

  FavoritesRepository(this._remoteDatasource);

  Future<({List<ChannelModel> data, PaginationMeta meta})> getFavorites({
    int page = 1,
  }) {
    return _remoteDatasource.getFavorites(page: page);
  }

  Future<void> addFavorite(int channelId) {
    return _remoteDatasource.addFavorite(channelId);
  }

  Future<void> removeFavorite(int channelId) {
    return _remoteDatasource.removeFavorite(channelId);
  }
}

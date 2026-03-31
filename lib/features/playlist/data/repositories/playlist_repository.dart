import '../datasources/playlist_remote_datasource.dart';

class PlaylistRepository {
  final PlaylistRemoteDatasource _datasource;

  PlaylistRepository(this._datasource);

  Future<String> getPlaylistLink() => _datasource.getPlaylistLink();

  Future<String> validateToken(String apiToken) =>
      _datasource.validateToken(apiToken);
}

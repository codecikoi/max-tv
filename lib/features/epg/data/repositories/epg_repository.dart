import '../datasources/epg_remote_datasource.dart';

/// Simplified EPG repository. The API does not have a programs listing endpoint.
/// Current program info comes embedded in the channel response.
class EpgRepository {
  final EpgRemoteDatasource _remoteDatasource;

  EpgRepository(this._remoteDatasource);

  Future<String> getArchiveLink(int programId) {
    return _remoteDatasource.getArchiveLink(programId);
  }
}

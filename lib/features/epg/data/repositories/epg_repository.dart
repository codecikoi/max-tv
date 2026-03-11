import '../datasources/epg_remote_datasource.dart';

class EpgRepository {
  final EpgRemoteDatasource _remoteDatasource;

  EpgRepository(this._remoteDatasource);

  Future<String> getArchiveLink(int programId) {
    return _remoteDatasource.getArchiveLink(programId);
  }
}

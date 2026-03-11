import '../datasources/epg_remote_datasource.dart';
import '../models/program_model.dart';

class EpgRepository {
  final EpgRemoteDatasource _remoteDatasource;

  EpgRepository(this._remoteDatasource);

  Future<List<ProgramModel>> getPrograms(String channelId, DateTime date) {
    return _remoteDatasource.getPrograms(channelId, date);
  }
}

import '../../../../core/models/pagination_meta.dart';
import '../datasources/epg_remote_datasource.dart';
import '../models/program_model.dart';

class EpgRepository {
  final EpgRemoteDatasource _remoteDatasource;

  EpgRepository(this._remoteDatasource);

  Future<({List<ProgramModel> data, PaginationMeta meta})> getPrograms(
    int channelId, {
    int page = 1,
    String? date,
  }) {
    return _remoteDatasource.getPrograms(channelId, page: page, date: date);
  }

  Future<({List<ProgramModel> data, PaginationMeta meta})> getArchivePrograms(
    int channelId, {
    int page = 1,
  }) {
    return _remoteDatasource.getArchivePrograms(channelId, page: page);
  }

  Future<List<ProgramModel>> getUpcomingPrograms({int limit = 5}) {
    return _remoteDatasource.getUpcomingPrograms(limit: limit);
  }

  Future<({List<ProgramModel> data, PaginationMeta meta})> searchPrograms({
    String? search,
    int page = 1,
  }) {
    return _remoteDatasource.searchPrograms(search: search, page: page);
  }

  Future<String> getArchiveLink(int programId) {
    return _remoteDatasource.getArchiveLink(programId);
  }
}

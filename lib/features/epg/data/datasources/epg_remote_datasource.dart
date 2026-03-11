import '../../../../core/models/pagination_meta.dart';
import '../../../../core/network/dio_client.dart';
import '../models/program_model.dart';

class EpgRemoteDatasource {
  final DioClient _dioClient;

  EpgRemoteDatasource(this._dioClient);

  Future<({List<ProgramModel> data, PaginationMeta meta})> getPrograms(
    int channelId, {
    int page = 1,
    int perPage = 50,
    String? date,
  }) async {
    final response = await _dioClient.dio.get(
      '/programs/$channelId',
      queryParameters: {
        'current_page': page,
        'per_page': perPage,
        if (date != null) 'date': date,
      },
    );
    final List data = response.data['data'] as List;
    final meta = PaginationMeta.fromJson(
      response.data['meta'] as Map<String, dynamic>,
    );
    return (
      data: data
          .map((json) => ProgramModel.fromJson(json as Map<String, dynamic>))
          .toList(),
      meta: meta,
    );
  }

  Future<String> getArchiveLink(int programId) async {
    final response = await _dioClient.dio.get('/archive', queryParameters: {
      'program': programId,
    });
    return response.data['link'] as String;
  }
}

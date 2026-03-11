import '../../../../core/network/dio_client.dart';
import '../models/program_model.dart';

class EpgRemoteDatasource {
  final DioClient _dioClient;

  EpgRemoteDatasource(this._dioClient);

  Future<List<ProgramModel>> getPrograms(String channelId, DateTime date) async {
    final response = await _dioClient.dio.get(
      '/channels/$channelId/programs',
      queryParameters: {
        'date': date.toIso8601String().split('T').first,
      },
    );
    final List data = response.data['data'];
    return data.map((json) => ProgramModel.fromJson(json)).toList();
  }
}

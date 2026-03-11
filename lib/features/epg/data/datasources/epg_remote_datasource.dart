import '../../../../core/network/dio_client.dart';

class EpgRemoteDatasource {
  final DioClient _dioClient;

  EpgRemoteDatasource(this._dioClient);

  Future<String> getArchiveLink(int programId) async {
    final response = await _dioClient.dio.get('/archive', queryParameters: {
      'program': programId,
    });
    return response.data['link'] as String;
  }
}

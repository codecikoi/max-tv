import '../../../../core/network/dio_client.dart';

/// The API does not expose a separate EPG endpoint.
/// Archive links can be retrieved for a given program.
class EpgRemoteDatasource {
  final DioClient _dioClient;

  EpgRemoteDatasource(this._dioClient);

  /// Get archive HLS link for a program.
  Future<String> getArchiveLink(int programId) async {
    final response = await _dioClient.dio.get('/archive', queryParameters: {
      'program': programId,
    });
    return response.data['link'] as String;
  }
}

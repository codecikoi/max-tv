import '../../../../core/network/dio_client.dart';
import '../models/device_auth_model.dart';

class DeviceAuthRemoteDatasource {
  final DioClient _dioClient;

  DeviceAuthRemoteDatasource(this._dioClient);

  Future<Map<String, dynamic>> authorize(DeviceAuthRequest request) async {
    final response = await _dioClient.dio.post(
      '/oauth/device/authorizations/authorize',
      data: request.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> approve(DeviceAuthApproval approval) async {
    final response = await _dioClient.dio.post(
      '/oauth/device/authorizations/approve',
      data: approval.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deny(DeviceAuthApproval denial) async {
    final response = await _dioClient.dio.post(
      '/oauth/device/authorizations/deny',
      data: denial.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }
}

import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class AccountRepository {
  final DioClient _dioClient;

  AccountRepository(this._dioClient);

  Future<UserModel> getProfile() async {
    final response = await _dioClient.dio.get('/profile');
    return UserModel.fromJson(response.data['data']);
  }
}

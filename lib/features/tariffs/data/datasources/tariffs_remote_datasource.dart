import '../../../../core/network/dio_client.dart';
import '../models/tariff_model.dart';

class TariffsRemoteDatasource {
  final DioClient _dioClient;

  TariffsRemoteDatasource(this._dioClient);

  Future<List<TariffModel>> getTariffs() async {
    final response = await _dioClient.dio.get('/tariffs');
    final raw = response.data;
    final data = (raw is List ? raw : raw['data'] as List);
    return data
        .map((e) => TariffModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> getPaymentLink({required int amount}) async {
    final response = await _dioClient.dio.get(
      '/payments/link',
      queryParameters: {'amount': amount, 'lang': 'ENG'},
    );
    return response.data['link'] as String;
  }
}

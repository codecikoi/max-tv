import '../datasources/tariffs_remote_datasource.dart';
import '../models/tariff_model.dart';

class TariffsRepository {
  final TariffsRemoteDatasource _remoteDatasource;

  TariffsRepository(this._remoteDatasource);

  Future<List<TariffModel>> getTariffs() {
    return _remoteDatasource.getTariffs();
  }
}

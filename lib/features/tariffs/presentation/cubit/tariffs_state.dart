import '../../data/models/tariff_model.dart';

abstract class TariffsState {}

class TariffsInitial extends TariffsState {}

class TariffsLoading extends TariffsState {}

class TariffsLoaded extends TariffsState {
  final List<TariffModel> tariffs;

  TariffsLoaded(this.tariffs);
}

class TariffsError extends TariffsState {
  final String message;

  TariffsError(this.message);
}

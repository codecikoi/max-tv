import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tariffs_repository.dart';
import 'tariffs_state.dart';

class TariffsCubit extends Cubit<TariffsState> {
  final TariffsRepository _repository;

  TariffsCubit(this._repository) : super(TariffsInitial());

  Future<void> loadTariffs() async {
    emit(TariffsLoading());
    try {
      final tariffs = await _repository.getTariffs();
      emit(TariffsLoaded(tariffs));
    } catch (e) {
      emit(TariffsError(e.toString()));
    }
  }
}

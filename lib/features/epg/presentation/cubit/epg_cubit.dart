import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/epg_repository.dart';
import 'epg_state.dart';

class EpgCubit extends Cubit<EpgState> {
  final EpgRepository _repository;
  late String _channelId;

  EpgCubit(this._repository) : super(EpgInitial());

  Future<void> loadPrograms(String channelId, {DateTime? date}) async {
    _channelId = channelId;
    final selectedDate = date ?? DateTime.now();
    emit(EpgLoading());
    try {
      final programs = await _repository.getPrograms(channelId, selectedDate);
      emit(EpgLoaded(programs: programs, selectedDate: selectedDate));
    } catch (e) {
      emit(EpgError(e.toString()));
    }
  }

  Future<void> changeDate(DateTime date) async {
    await loadPrograms(_channelId, date: date);
  }
}

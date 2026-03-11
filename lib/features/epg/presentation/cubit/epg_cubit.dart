import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../channels/data/repositories/channels_repository.dart';
import '../../data/repositories/epg_repository.dart';
import 'epg_state.dart';

/// EPG cubit now loads channel detail (which includes current program info)
/// since the API has no separate EPG listing endpoint.
class EpgCubit extends Cubit<EpgState> {
  final ChannelsRepository _channelsRepository;
  final EpgRepository _epgRepository;

  EpgCubit(this._channelsRepository, this._epgRepository) : super(EpgInitial());

  Future<void> loadChannel(int channelId) async {
    emit(EpgLoading());
    try {
      final channel = await _channelsRepository.getChannel(
        channelId,
        include: 'categories',
      );
      emit(EpgLoaded(channel: channel));
    } catch (e) {
      emit(EpgError(e.toString()));
    }
  }

  Future<void> loadArchive(int programId) async {
    emit(EpgLoading());
    try {
      final link = await _epgRepository.getArchiveLink(programId);
      emit(EpgArchiveLoaded(archiveLink: link));
    } catch (e) {
      emit(EpgError(e.toString()));
    }
  }
}

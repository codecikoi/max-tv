import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/channels_repository.dart';
import 'channels_state.dart';

class ChannelsCubit extends Cubit<ChannelsState> {
  final ChannelsRepository _repository;

  ChannelsCubit(this._repository) : super(ChannelsInitial());

  Future<void> loadChannels() async {
    emit(ChannelsLoading());
    try {
      final channels = await _repository.getChannels();
      emit(ChannelsLoaded(channels: channels));
    } catch (e) {
      emit(ChannelsError(e.toString()));
    }
  }

  Future<void> searchChannels(String query) async {
    emit(ChannelsLoading());
    try {
      final channels = query.isEmpty
          ? await _repository.getChannels()
          : await _repository.searchChannels(query);
      emit(ChannelsLoaded(channels: channels, searchQuery: query));
    } catch (e) {
      emit(ChannelsError(e.toString()));
    }
  }
}

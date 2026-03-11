import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/channels_repository.dart';
import 'channels_state.dart';

class ChannelsCubit extends Cubit<ChannelsState> {
  final ChannelsRepository _repository;

  ChannelsCubit(this._repository) : super(ChannelsInitial());

  Future<void> loadChannels({int page = 1}) async {
    emit(ChannelsLoading());
    try {
      final result = await _repository.getChannels(page: page);
      emit(ChannelsLoaded(channels: result.data, meta: result.meta));
    } catch (e) {
      emit(ChannelsError(e.toString()));
    }
  }

  Future<void> searchChannels(String query, {int page = 1}) async {
    emit(ChannelsLoading());
    try {
      final result = await _repository.getChannels(page: page, search: query.isEmpty ? null : query);
      emit(ChannelsLoaded(
        channels: result.data,
        meta: result.meta,
        searchQuery: query,
      ));
    } catch (e) {
      emit(ChannelsError(e.toString()));
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is ChannelsLoaded && currentState.meta.hasNextPage) {
      try {
        final nextPage = currentState.meta.currentPage + 1;
        final result = await _repository.getChannels(
          page: nextPage,
          search: currentState.searchQuery.isEmpty ? null : currentState.searchQuery,
        );
        emit(ChannelsLoaded(
          channels: [...currentState.channels, ...result.data],
          meta: result.meta,
          searchQuery: currentState.searchQuery,
        ));
      } catch (e) {
        emit(ChannelsError(e.toString()));
      }
    }
  }
}

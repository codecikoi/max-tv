import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../data/repositories/channels_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import 'channels_state.dart';

class ChannelsCubit extends Cubit<ChannelsState> {
  final ChannelsRepository _repository;
  final FavoritesRepository _favoritesRepository;

  ChannelsCubit(this._repository, this._favoritesRepository) : super(ChannelsInitial());

  Future<void> loadChannels({int page = 1}) async {
    emit(ChannelsLoading());
    try {
      final result = await _repository.getChannels(page: page);
      emit(ChannelsLoaded(channels: result.data, meta: result.meta));
    } catch (e) {
      _handleError(e);
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
      _handleError(e);
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
        _handleError(e);
      }
    }
  }

  Future<void> loadFavorites({int page = 1}) async {
    emit(ChannelsLoading());
    try {
      final result = await _favoritesRepository.getFavorites(page: page);
      emit(ChannelsLoaded(channels: result.data, meta: result.meta));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> loadByCategory(int categoryId) async {
    emit(ChannelsLoading());
    try {
      final category = await _repository.getCategory(categoryId);
      final channels = category.channels ?? [];
      emit(ChannelsLoaded(
        channels: channels,
        meta: const PaginationMeta(currentPage: 1, lastPage: 1, total: 0, perPage: 15),
      ));
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(Object e) {
    if (e is DioException && e.response?.statusCode == 402) {
      emit(ChannelsTariffExpired());
    } else {
      emit(ChannelsError(e is DioException ? (e.message ?? e.toString()) : e.toString()));
    }
  }
}

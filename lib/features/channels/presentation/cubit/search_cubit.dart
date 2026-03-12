import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/channels_repository.dart';
import '../../../epg/data/repositories/epg_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ChannelsRepository _channelsRepository;
  final EpgRepository _epgRepository;

  SearchMode _currentMode = SearchMode.channels;
  String _currentQuery = '';
  Timer? _debounce;

  SearchCubit(this._channelsRepository, this._epgRepository)
      : super(SearchInitial());

  SearchMode get currentMode => _currentMode;

  void setMode(SearchMode mode) {
    _currentMode = mode;
    if (_currentQuery.isNotEmpty) {
      _performSearch(_currentQuery);
    }
  }

  void search(String query) {
    _currentQuery = query;
    _debounce?.cancel();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query, {int page = 1}) async {
    emit(SearchLoading());
    try {
      switch (_currentMode) {
        case SearchMode.channels:
          final result = await _channelsRepository.getChannels(
            page: page,
            search: query,
          );
          emit(SearchChannelsLoaded(
            channels: result.data,
            meta: result.meta,
            query: query,
          ));
          break;
        case SearchMode.programs:
          final result = await _epgRepository.searchPrograms(
            search: query,
            page: page,
          );
          emit(SearchProgramsLoaded(
            programs: result.data,
            meta: result.meta,
            query: query,
          ));
          break;
      }
    } catch (e) {
      if (e is DioException) {
        emit(SearchError(e.message ?? e.toString()));
      } else {
        emit(SearchError(e.toString()));
      }
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is SearchChannelsLoaded &&
        currentState.meta.hasNextPage) {
      try {
        final nextPage = currentState.meta.currentPage + 1;
        final result = await _channelsRepository.getChannels(
          page: nextPage,
          search: currentState.query,
        );
        emit(SearchChannelsLoaded(
          channels: [...currentState.channels, ...result.data],
          meta: result.meta,
          query: currentState.query,
        ));
      } catch (_) {}
    } else if (currentState is SearchProgramsLoaded &&
        currentState.meta.hasNextPage) {
      try {
        final nextPage = currentState.meta.currentPage + 1;
        final result = await _epgRepository.searchPrograms(
          search: currentState.query,
          page: nextPage,
        );
        emit(SearchProgramsLoaded(
          programs: [...currentState.programs, ...result.data],
          meta: result.meta,
          query: currentState.query,
        ));
      } catch (_) {}
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

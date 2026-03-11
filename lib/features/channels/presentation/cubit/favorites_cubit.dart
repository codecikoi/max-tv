import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(FavoritesInitial());

  Future<void> loadFavorites({int page = 1}) async {
    emit(FavoritesLoading());
    try {
      final result = await _repository.getFavorites(page: page);
      emit(FavoritesLoaded(channels: result.data, meta: result.meta));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> addFavorite(int channelId) async {
    try {
      await _repository.addFavorite(channelId);
      await loadFavorites();
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> removeFavorite(int channelId) async {
    try {
      await _repository.removeFavorite(channelId);
      await loadFavorites();
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}

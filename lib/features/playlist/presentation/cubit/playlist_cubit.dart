import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/playlist_repository.dart';
import 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final PlaylistRepository _repository;

  PlaylistCubit(this._repository) : super(PlaylistInitial());

  Future<void> checkPlaylist() async {
    emit(PlaylistLoading());
    try {
      final link = await _repository.getPlaylistLink();
      emit(PlaylistHasLink(link));
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 402) {
        emit(PlaylistTariffExpired());
      } else {
        emit(PlaylistNoLink());
      }
    }
  }

  Future<void> validatePlaylistUrl(String url) async {
    final token = _extractToken(url);
    if (token == null || token.isEmpty) {
      emit(const PlaylistError('Неверная ссылка на плейлист'));
      return;
    }

    emit(PlaylistValidating());
    try {
      await _repository.validateToken(token);
      emit(PlaylistValidated());
    } catch (e) {
      if (e is DioException) {
        emit(PlaylistError(e.message ?? 'Что-то пошло не так'));
      } else {
        emit(const PlaylistError('Что-то пошло не так'));
      }
    }
  }

  void resetState() => emit(PlaylistInitial());

  String? _extractToken(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final playlistIndex = segments.indexOf('playlist');
    if (playlistIndex >= 0 && playlistIndex + 1 < segments.length) {
      return segments[playlistIndex + 1];
    }
    return url.trim();
  }
}

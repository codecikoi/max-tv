import 'package:equatable/equatable.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object?> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistHasLink extends PlaylistState {
  final String link;

  const PlaylistHasLink(this.link);

  @override
  List<Object?> get props => [link];
}

class PlaylistNoLink extends PlaylistState {}

class PlaylistValidating extends PlaylistState {}

class PlaylistValidated extends PlaylistState {}

class PlaylistError extends PlaylistState {
  final String message;

  const PlaylistError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlaylistTariffExpired extends PlaylistState {}

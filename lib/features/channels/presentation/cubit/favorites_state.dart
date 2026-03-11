import 'package:equatable/equatable.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../data/models/channel_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ChannelModel> channels;
  final PaginationMeta meta;

  const FavoritesLoaded({required this.channels, required this.meta});

  @override
  List<Object?> get props => [channels, meta];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

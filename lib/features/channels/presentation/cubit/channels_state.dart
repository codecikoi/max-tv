import 'package:equatable/equatable.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../data/models/channel_model.dart';

abstract class ChannelsState extends Equatable {
  const ChannelsState();

  @override
  List<Object?> get props => [];
}

class ChannelsInitial extends ChannelsState {}

class ChannelsLoading extends ChannelsState {}

class ChannelsLoaded extends ChannelsState {
  final List<ChannelModel> channels;
  final PaginationMeta meta;
  final String searchQuery;

  const ChannelsLoaded({
    required this.channels,
    required this.meta,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [channels, meta, searchQuery];
}

class ChannelsError extends ChannelsState {
  final String message;

  const ChannelsError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
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
  final String searchQuery;

  const ChannelsLoaded({
    required this.channels,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [channels, searchQuery];
}

class ChannelsError extends ChannelsState {
  final String message;

  const ChannelsError(this.message);

  @override
  List<Object?> get props => [message];
}

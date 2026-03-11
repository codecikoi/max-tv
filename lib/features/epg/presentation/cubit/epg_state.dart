import 'package:equatable/equatable.dart';
import '../../../channels/data/models/channel_model.dart';

abstract class EpgState extends Equatable {
  const EpgState();

  @override
  List<Object?> get props => [];
}

class EpgInitial extends EpgState {}

class EpgLoading extends EpgState {}

class EpgLoaded extends EpgState {
  final ChannelModel channel;

  const EpgLoaded({required this.channel});

  @override
  List<Object?> get props => [channel];
}

class EpgArchiveLoaded extends EpgState {
  final String archiveLink;

  const EpgArchiveLoaded({required this.archiveLink});

  @override
  List<Object?> get props => [archiveLink];
}

class EpgError extends EpgState {
  final String message;

  const EpgError(this.message);

  @override
  List<Object?> get props => [message];
}

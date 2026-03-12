import 'package:equatable/equatable.dart';
import '../../../../core/models/pagination_meta.dart';
import '../../data/models/channel_model.dart';
import '../../../epg/data/models/program_model.dart';

enum SearchMode { channels, programs }

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchChannelsLoaded extends SearchState {
  final List<ChannelModel> channels;
  final PaginationMeta meta;
  final String query;

  const SearchChannelsLoaded({
    required this.channels,
    required this.meta,
    required this.query,
  });

  @override
  List<Object?> get props => [channels, meta, query];
}

class SearchProgramsLoaded extends SearchState {
  final List<ProgramModel> programs;
  final PaginationMeta meta;
  final String query;

  const SearchProgramsLoaded({
    required this.programs,
    required this.meta,
    required this.query,
  });

  @override
  List<Object?> get props => [programs, meta, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

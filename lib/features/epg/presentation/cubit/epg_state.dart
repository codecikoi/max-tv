import 'package:equatable/equatable.dart';
import '../../data/models/program_model.dart';

abstract class EpgState extends Equatable {
  const EpgState();

  @override
  List<Object?> get props => [];
}

class EpgInitial extends EpgState {}

class EpgLoading extends EpgState {}

class EpgLoaded extends EpgState {
  final List<ProgramModel> programs;
  final DateTime selectedDate;

  const EpgLoaded({
    required this.programs,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [programs, selectedDate];
}

class EpgError extends EpgState {
  final String message;

  const EpgError(this.message);

  @override
  List<Object?> get props => [message];
}

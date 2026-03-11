import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> loadProfile() async {
    emit(AccountLoading());
    try {
      final user = await _repository.getProfile();
      emit(AccountLoaded(user));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}

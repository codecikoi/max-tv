import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> loadProfile() async {
    emit(AccountLoading());
    try {
      final user = await _repository.getCachedUser();
      if (user != null) {
        emit(AccountLoaded(user));
      } else {
        emit(AccountEmpty());
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> updateUser(UserModel user) async {
    await _repository.cacheUser(user);
    emit(AccountLoaded(user));
  }

  Future<void> clearProfile() async {
    await _repository.clearUser();
    emit(AccountEmpty());
  }
}

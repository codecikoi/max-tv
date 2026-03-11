import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';
import '../../../../core/di/injection.dart';
import '../../data/repositories/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> loadProfile() async {
    emit(AccountLoading());
    try {
      final cached = await _repository.getCachedUser();
      if (cached != null) {
        emit(AccountLoaded(cached));
      }
      final user = await _repository.fetchProfile();
      emit(AccountLoaded(user));
    } catch (e, st) {
      getIt<Talker>().handle(e, st, 'AccountCubit.loadProfile');
      if (state is! AccountLoaded) {
        emit(AccountEmpty());
      }
    }
  }

  Future<void> updateProfile({
    required String name,
    required String login,
  }) async {
    try {
      final user = await _repository.updateProfile(name: name, login: login);
      emit(AccountLoaded(user));
    } catch (e, st) {
      getIt<Talker>().handle(e, st, 'AccountCubit.updateProfile');
      rethrow;
    }
  }

  Future<void> clearProfile() async {
    await _repository.clearUser();
    emit(AccountEmpty());
  }
}

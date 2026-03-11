import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/channels/data/datasources/channels_remote_datasource.dart';
import '../../features/channels/data/repositories/channels_repository.dart';
import '../../features/channels/presentation/cubit/channels_cubit.dart';
import '../../features/epg/data/datasources/epg_remote_datasource.dart';
import '../../features/epg/data/repositories/epg_repository.dart';
import '../../features/epg/presentation/cubit/epg_cubit.dart';
import '../../features/account/data/repositories/account_repository.dart';
import '../../features/account/presentation/cubit/account_cubit.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Channels
  getIt.registerLazySingleton<ChannelsRemoteDatasource>(
    () => ChannelsRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ChannelsRepository>(
    () => ChannelsRepository(getIt<ChannelsRemoteDatasource>()),
  );
  getIt.registerFactory<ChannelsCubit>(
    () => ChannelsCubit(getIt<ChannelsRepository>()),
  );

  // EPG
  getIt.registerLazySingleton<EpgRemoteDatasource>(
    () => EpgRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<EpgRepository>(
    () => EpgRepository(getIt<EpgRemoteDatasource>()),
  );
  getIt.registerFactory<EpgCubit>(
    () => EpgCubit(getIt<EpgRepository>()),
  );

  // Account
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepository(getIt<DioClient>()),
  );
  getIt.registerFactory<AccountCubit>(
    () => AccountCubit(getIt<AccountRepository>()),
  );
}

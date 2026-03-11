import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../network/dio_client.dart';
import '../network/token_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/channels/data/datasources/channels_remote_datasource.dart';
import '../../features/channels/data/repositories/channels_repository.dart';
import '../../features/channels/presentation/cubit/channels_cubit.dart';
import '../../features/channels/data/datasources/favorites_remote_datasource.dart';
import '../../features/channels/data/repositories/favorites_repository.dart';
import '../../features/channels/presentation/cubit/favorites_cubit.dart';
import '../../features/epg/data/datasources/epg_remote_datasource.dart';
import '../../features/epg/data/repositories/epg_repository.dart';
import '../../features/epg/presentation/cubit/epg_cubit.dart';
import '../../features/account/data/repositories/account_repository.dart';
import '../../features/account/presentation/cubit/account_cubit.dart';
import '../../features/blog/data/datasources/blog_remote_datasource.dart';
import '../../features/blog/data/repositories/blog_repository.dart';
import '../../features/device_auth/data/datasources/device_auth_remote_datasource.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core
  getIt.registerLazySingleton<Talker>(() => Talker());
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<TokenStorage>(), getIt<Talker>()),
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthRemoteDatasource>(), getIt<TokenStorage>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

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

  // Favorites
  getIt.registerLazySingleton<FavoritesRemoteDatasource>(
    () => FavoritesRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepository(getIt<FavoritesRemoteDatasource>()),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(getIt<FavoritesRepository>()),
  );

  // EPG
  getIt.registerLazySingleton<EpgRemoteDatasource>(
    () => EpgRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<EpgRepository>(
    () => EpgRepository(getIt<EpgRemoteDatasource>()),
  );
  getIt.registerFactory<EpgCubit>(
    () => EpgCubit(getIt<ChannelsRepository>(), getIt<EpgRepository>()),
  );

  // Account
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepository(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AccountCubit>(
    () => AccountCubit(getIt<AccountRepository>()),
  );

  // Blog
  getIt.registerLazySingleton<BlogRemoteDatasource>(
    () => BlogRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<BlogRepository>(
    () => BlogRepository(getIt<BlogRemoteDatasource>()),
  );

  // Device Auth
  getIt.registerLazySingleton<DeviceAuthRemoteDatasource>(
    () => DeviceAuthRemoteDatasource(getIt<DioClient>()),
  );
}

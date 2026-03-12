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
import '../../features/tariffs/data/datasources/tariffs_remote_datasource.dart';
import '../../features/tariffs/data/repositories/tariffs_repository.dart';
import '../../features/tariffs/presentation/cubit/tariffs_cubit.dart';
import '../../features/device_auth/data/datasources/device_auth_remote_datasource.dart';
import '../../features/channels/presentation/cubit/search_cubit.dart';
import '../../features/channels/presentation/widgets/category_filter_sheet.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<Talker>(() => Talker());
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<TokenStorage>(), getIt<Talker>()),
  );

  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthRemoteDatasource>(), getIt<TokenStorage>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ChannelsRemoteDatasource>(
    () => ChannelsRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ChannelsRepository>(
    () => ChannelsRepository(getIt<ChannelsRemoteDatasource>()),
  );

  getIt.registerLazySingleton<FavoritesRemoteDatasource>(
    () => FavoritesRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepository(getIt<FavoritesRemoteDatasource>()),
  );

  getIt.registerFactory<ChannelsCubit>(
    () => ChannelsCubit(getIt<ChannelsRepository>(), getIt<FavoritesRepository>()),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(getIt<FavoritesRepository>()),
  );

  getIt.registerLazySingleton<EpgRemoteDatasource>(
    () => EpgRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<EpgRepository>(
    () => EpgRepository(getIt<EpgRemoteDatasource>()),
  );
  getIt.registerFactory<EpgCubit>(
    () => EpgCubit(getIt<ChannelsRepository>(), getIt<EpgRepository>()),
  );

  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepository(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AccountCubit>(
    () => AccountCubit(getIt<AccountRepository>()),
  );

  getIt.registerLazySingleton<BlogRemoteDatasource>(
    () => BlogRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<BlogRepository>(
    () => BlogRepository(getIt<BlogRemoteDatasource>()),
  );

  getIt.registerLazySingleton<TariffsRemoteDatasource>(
    () => TariffsRemoteDatasource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<TariffsRepository>(
    () => TariffsRepository(getIt<TariffsRemoteDatasource>()),
  );
  getIt.registerFactory<TariffsCubit>(
    () => TariffsCubit(getIt<TariffsRepository>()),
  );

  getIt.registerLazySingleton<DeviceAuthRemoteDatasource>(
    () => DeviceAuthRemoteDatasource(getIt<DioClient>()),
  );

  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<ChannelsRepository>(), getIt<EpgRepository>()),
  );

  getIt.registerLazySingleton<CategoryFilterCache>(
    () => CategoryFilterCache(),
  );
}

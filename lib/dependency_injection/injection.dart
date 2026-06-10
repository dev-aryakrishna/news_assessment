import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/local_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/data/datasource/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(sl<SharedPreferences>()),
  );

  // Supabase

  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // DataSource

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // Repository

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
}

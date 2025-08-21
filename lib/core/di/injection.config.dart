// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/cubit/home_cubit.dart' as _i1032;
import '../../features/login/cubit/login_cubit.dart' as _i209;
import '../../features/sign_up/cubit/sign_up_cubit.dart' as _i745;
import '../data/datasource/local/storage_adapter.dart' as _i434;
import '../data/datasource/local/user_local_datasource.dart' as _i455;
import '../data/datasource/remote/login_remote_datasource.dart' as _i1034;
import '../data/datasource/remote/user_remote_datasource.dart' as _i853;
import '../domain/repository/firebase_auth_repository.dart' as _i827;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalModule = _$ExternalModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => externalModule.firebaseAuth);
    gh.singleton<_i853.UserRemoteDatasource>(
        () => _i853.UserRemoteDataSourceImpl());
    gh.singleton<_i434.LocalStorage>(() => _i434.SharedPreferencesAdapter());
    gh.singleton<_i1034.LoginRemoteDatasource>(
        () => _i1034.LoginRemoteDatasourceImpl(gh<_i59.FirebaseAuth>()));
    gh.singleton<_i455.UserLocalDatasource>(
        () => _i455.UserLocalDataSourceImpl(gh<_i434.LocalStorage>()));
    gh.factory<_i827.AuthRepository>(() => _i827.FirebaseAuthRepository(
          gh<_i1034.LoginRemoteDatasource>(),
          gh<_i853.UserRemoteDatasource>(),
          gh<_i455.UserLocalDatasource>(),
        ));
    gh.factory<_i209.LoginCubit>(
        () => _i209.LoginCubit(gh<_i827.AuthRepository>()));
    gh.factory<_i745.SignUpCubit>(
        () => _i745.SignUpCubit(gh<_i827.AuthRepository>()));
    gh.factory<_i1032.HomeCubit>(() => _i1032.HomeCubit(
          gh<_i827.AuthRepository>(),
          gh<_i455.UserLocalDatasource>(),
        ));
    return this;
  }
}

class _$ExternalModule extends _i464.ExternalModule {}

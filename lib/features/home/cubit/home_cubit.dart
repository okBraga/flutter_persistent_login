import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_login/core/data/datasource/local/user_local_datasource.dart';
import 'package:flutter_persistent_login/core/domain/entity/user_entity.dart';
import 'package:flutter_persistent_login/core/domain/repository/firebase_auth_repository.dart';
import 'package:injectable/injectable.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final UserEntity user;

  HomeLoaded({required this.user});
}

class HomeLoading extends HomeState {}

class HomeLoggedOut extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final UserLocalDatasource _userLocalDataSource;

  HomeCubit(this._authRepository, this._userLocalDataSource) : super(HomeInitial());

  Future<void> loadUser() async {
    emit(HomeLoading());
    final user = await _userLocalDataSource.getUser();
    if (user == null) {
      return;
    }
    emit(HomeLoaded(user: user));
  }

  Future<void> logout() async {
    try {
      emit(HomeLoading());
      await _authRepository.logout();
      emit(HomeLoggedOut());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

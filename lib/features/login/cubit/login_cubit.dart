import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_login/helpers/auth_error_messages.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import '../../../core/domain/repository/firebase_auth_repository.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authDataSource;

  LoginCubit(this._authDataSource) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final user = await _authDataSource.signIn(email, password);
      emit(LoginSuccess());
    } on AuthenticationException catch (e) {
      final errorMessage = mapErrorMessage(e.code);
      emit(
        LoginError(errorMessage),
      );
    }
  }
}

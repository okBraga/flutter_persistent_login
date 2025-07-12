import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_login/core/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import '../../../core/domain/repository/firebase_auth_repository.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final UserEntity user;

  const SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpError extends SignUpState {
  final String message;

  const SignUpError(this.message);

  @override
  List<Object?> get props => [message];
}

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authDataSource;

  SignUpCubit(this._authDataSource) : super(SignUpInitial());

  Future<void> signUp(String email, String password, String name) async {
    emit(SignUpLoading());
    try {
      final user = await _authDataSource.signUp(email, password, name);

      emit(SignUpSuccess(user));
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }
}

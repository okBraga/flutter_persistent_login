import 'package:flutter_persistent_login/core/domain/repository/firebase_auth_repository.dart';

String mapErrorMessage(AuthErrorCode code) {
  return switch (code) {
    AuthErrorCode.invalidEmail => 'E-mail Inválido',
    AuthErrorCode.userDisabled => 'Usuário Desativado',
    AuthErrorCode.userNotFound => 'Usuário não encontrado',
    AuthErrorCode.wrongPassword => 'E-mail ou Senha Incorretos',
    AuthErrorCode.tooManyRequests => 'Você excedeu o limite de tentaivas, tente novamente mais tarde',
    AuthErrorCode.userTokenExpired => 'Ocorreu um erro ao realizar essa operação, tente novamente mais tarde',
    AuthErrorCode.networkRequestFailed => 'Ocorreu um erro ao realizar essa operação, tente novamente mais tarde',
    AuthErrorCode.invalidCredential => 'E-mail ou Senha Incorretos',
    AuthErrorCode.operationNotAllowed => 'Ocorreu um erro ao realizar essa operação, tente novamente mais tarde',
    AuthErrorCode.emailAlreadyInUse => 'E-mail já em uso',
    AuthErrorCode.weakPassowrd => 'Senha muito fraca',
    AuthErrorCode.unknown => 'Ocorreu um erro ao realizar essa operação, tente novamente mais tarde',
  };
}
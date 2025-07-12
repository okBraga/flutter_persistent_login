import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_persistent_login/core/data/datasource/local/user_local_datasource.dart';
import 'package:flutter_persistent_login/core/data/datasource/remote/user_remote_datasource.dart';
import 'package:flutter_persistent_login/core/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';

/*
email-already-in-use:
Thrown if there already exists an account with the given email address.
invalid-email:
Thrown if the email address is not valid.
operation-not-allowed:
Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
weak-password:
Thrown if the password is not strong enough.
too-many-requests:
Thrown if the user sent too many requests at the same time, for security the api will not allow too many attempts at the same time, user will have to wait for some time
user-token-expired:
Thrown if the user is no longer authenticated since his refresh token has been expired
network-request-failed:
Thrown if there was a network request error, for example the user doesn't have internet connection
 */

enum LoginErrorCode {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  tooManyRequests,
  userTokenExpired,
  networkRequestFailed,
  invalidCredential,
  operationNotAllowed,
  unknown,
}

enum SignUpErrorCode {
  emailAlreadyInUse,
  invalidEmail,
  operationNotAllowed,
  weakPassowrd,
  tooManyRequests,
  userTokenExpired,
  networkRequestFailed,
  unknown,
}

class LoginException implements Exception {
  final LoginErrorCode code;

  LoginException({required this.code});
}

class SignUpException implements Exception {
  final SignUpErrorCode code;

  SignUpException({required this.code});
}

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String email, String password, String name);
  Future<void> logout();
}

@Injectable(as: AuthRepository)
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final UserRemoteDatasource _userRemoteDatasource;
  final UserLocalDatasource _userLocalDataSource;

  FirebaseAuthRepository(this._firebaseAuth, this._userRemoteDatasource, this._userLocalDataSource);

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Usuário não encontrado');
      }
      final user = await _userRemoteDatasource.getById(uid);

      if (user == null) {
        throw Exception('Usuário não encontrado');
      }
      await _userLocalDataSource.saveUser(user);

      return user;
    } on FirebaseAuthException catch (e) {
      final loginErrorCode = switch (e.code) {
        'invalid-email' => LoginErrorCode.invalidEmail,
        'user-disabled' => LoginErrorCode.userDisabled,
        'user-not-found' => LoginErrorCode.userNotFound,
        'wrong-password' => LoginErrorCode.wrongPassword,
        'too-many-requests' => LoginErrorCode.tooManyRequests,
        'user-token-expired' => LoginErrorCode.userTokenExpired,
        'network-request-failed' => LoginErrorCode.networkRequestFailed,
        'invalid-credential' => LoginErrorCode.invalidCredential,
        'operation-not-allowed' => LoginErrorCode.operationNotAllowed,
        _ => LoginErrorCode.unknown,
      };

      throw LoginException(code: loginErrorCode);
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Erro ao criar usuário');
      }
      final user = UserEntity(id: uid, email: email, name: name);
      await _userRemoteDatasource.save(user);
      await _userLocalDataSource.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      final signUpErrorCode = switch (e.code) {
        'email-already-in-use' => SignUpErrorCode.emailAlreadyInUse,
        'invalid-email' => SignUpErrorCode.invalidEmail,
        'operation-not-allowed' => SignUpErrorCode.operationNotAllowed,
        'weak-password' => SignUpErrorCode.weakPassowrd,
        'too-many-requests' => SignUpErrorCode.tooManyRequests,
        'user-token-expired' => SignUpErrorCode.userTokenExpired,
        'network-request-failed' => SignUpErrorCode.networkRequestFailed,
        _ => SignUpErrorCode.unknown,
      };

      throw SignUpException(code: signUpErrorCode);
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _userLocalDataSource.deletUser();
  }
}

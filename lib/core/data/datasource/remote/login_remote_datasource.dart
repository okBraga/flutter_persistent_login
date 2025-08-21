import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});
}

class SignupRequest {
  final String email;
  final String password;

  SignupRequest({required this.email, required this.password});
}

abstract class LoginRemoteDatasource {
  Future<String?> login(LoginRequest params);
  Future<String?> signup(SignupRequest params);
  Future<void> signOut();
}

@Singleton(as: LoginRemoteDatasource)
class LoginRemoteDatasourceImpl implements LoginRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  LoginRemoteDatasourceImpl(this._firebaseAuth);

  @override
  Future<String?> login(LoginRequest params) async {
    final LoginRequest(:email, :password) = params;
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user?.uid;
  }

  @override
  Future<String?> signup(SignupRequest params) async {
    final SignupRequest(:email, :password) = params;
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user?.uid;
  }
  
  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}

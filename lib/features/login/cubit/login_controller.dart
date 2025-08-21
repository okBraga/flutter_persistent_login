import 'package:flutter/foundation.dart';
import 'package:flutter_persistent_login/core/domain/repository/firebase_auth_repository.dart';

import '../../../helpers/auth_error_messages.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  bool isLoading = false;
  String? errorMessage;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signIn(email, password);
    } on AuthenticationException catch (e) {
      errorMessage = mapErrorMessage(e.code);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

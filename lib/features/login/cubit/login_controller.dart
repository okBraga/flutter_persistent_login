import 'package:flutter/foundation.dart';
import 'package:flutter_persistent_login/core/domain/repository/firebase_auth_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../helpers/auth_error_messages.dart';

class LoginException implements Exception {
  final String message;

  LoginException(this.message);
}

@Injectable()
class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  bool isLoading = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signIn(email, password);
    } on AuthenticationException catch (e) {
      final message = mapErrorMessage(e.code);
      throw LoginException(message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

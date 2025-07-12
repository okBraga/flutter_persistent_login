String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, insira seu nome';
  }
  if (value.length < 3) {
    return 'Por favor, insira um nome válido';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, insira seu email';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Por favor, insira um email válido';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, insira sua senha';
  }
  if (value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }
  return null;
}

String? validateRepeatPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Por favor, repita sua senha';
  }
  if (value != password) {
    return 'As senhas não coincidem';
  }
  return null;
}

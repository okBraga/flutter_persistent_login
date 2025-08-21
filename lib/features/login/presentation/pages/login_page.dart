import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_login/core/di/injection.dart';
import 'package:flutter_persistent_login/core/widgets/primary_button.dart';
import 'package:flutter_persistent_login/core/routes/app_routes.dart';
import 'package:flutter_persistent_login/features/login/cubit/login_cubit.dart';
import 'package:flutter_persistent_login/helpers/input_decoration.dart';
import 'package:flutter_persistent_login/helpers/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final loginCubit = getDependency<LoginCubit>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      bloc: loginCubit,
      listener: (context, state) {
        switch (state) {
          case LoginSuccess():
            Navigator.pushReplacementNamed(context, AppRoutes.home);
            break;
          case LoginError(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Acesse sua conta',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            validator: validateEmail,
                            decoration: customInputDecoration(hintText: 'Digite seu email'),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Senha',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: validatePassword,
                            decoration: customInputDecoration(hintText: 'Digite sua senha'),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                loginCubit.login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              },
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.signUp,
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Não tem uma conta? ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Cadastre-se',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

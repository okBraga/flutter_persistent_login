import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_login/core/di/injection.dart';
import 'package:flutter_persistent_login/core/shared/widgets/primary_button.dart';
import 'package:flutter_persistent_login/core/routes/app_routes.dart';
import 'package:flutter_persistent_login/features/sign_up/cubit/sign_up_cubit.dart';
import 'package:flutter_persistent_login/helpers/input_decoration.dart';
import 'package:flutter_persistent_login/helpers/validators.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  final signUpCubit = getIt.get<SignUpCubit>();

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      bloc: signUpCubit,
      listener: (context, state) {
        switch (state) {
          case SignUpSuccess():
            Navigator.pushReplacementNamed(context, AppRoutes.home);
            break;
          case SignUpError(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state is SignUpLoading;
        return GestureDetector(
          onTap: _unfocus,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Crie sua conta',
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
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            validator: validateName,
                            decoration: customInputDecoration(labelText: 'Nome'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            validator: validateEmail,
                            decoration: customInputDecoration(labelText: 'Email'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: validatePassword,
                            decoration: customInputDecoration(labelText: 'Senha'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _repeatPasswordController,
                            obscureText: true,
                            validator: (value) => validateRepeatPassword(
                              value,
                              _passwordController.text,
                            ),
                            decoration: customInputDecoration(labelText: 'Repita sua senha'),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              onPressed: () {
                                _unfocus();
                                if (_formKey.currentState!.validate()) {
                                  signUpCubit.signUp(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _nameController.text.trim(),
                                  );
                                }
                              },
                              child: const Text(
                                'Cadastrar',
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
                                Navigator.pushReplacementNamed(context, AppRoutes.login);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Já tem uma conta? ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Fazer login',
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

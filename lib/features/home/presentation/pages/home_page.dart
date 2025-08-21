import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_login/core/di/injection.dart';
import 'package:flutter_persistent_login/core/routes/app_routes.dart';
import 'package:flutter_persistent_login/core/widgets/primary_button.dart';
import 'package:flutter_persistent_login/features/home/cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeCubit = getDependency<HomeCubit>();

  @override
  void initState() {
    super.initState();
    homeCubit.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      bloc: homeCubit,
      listener: (context, state) {
        switch (state) {
          case HomeLoggedOut():
            Navigator.pushReplacementNamed(context, AppRoutes.login);
            break;
          case HomeError():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        switch (state) {
          case HomeLoaded():
            final user = state.user;
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bem vindo: ${user.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        homeCubit.logout();
                      },
                      child: Text(
                        'Desconectar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          case HomeLoading():
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}

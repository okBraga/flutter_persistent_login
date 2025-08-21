import 'package:flutter/material.dart';
import 'package:flutter_persistent_login/core/data/datasource/local/user_local_datasource.dart';
import 'package:flutter_persistent_login/core/di/injection.dart';
import 'package:flutter_persistent_login/core/routes/app_routes.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  
  Future<void> verifyUser() async {
    try {
      final user = await getDependency<UserLocalDatasource>().getUser();

      final route = user == null ? AppRoutes.login : AppRoutes.home;

      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void initState() {
    super.initState();

    verifyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

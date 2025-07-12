import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_persistent_login/core/di/injection.dart';
import 'package:flutter_persistent_login/core/routes/app_routes.dart';
import 'package:flutter_persistent_login/core/styles/theme.dart';
import 'package:flutter_persistent_login/features/app/auth_gate.dart';
import 'package:flutter_persistent_login/firebase_options.dart';
import 'package:flutter_persistent_login/features/home/presentation/pages/home_page.dart';
import 'package:flutter_persistent_login/features/login/presentation/pages/login_page.dart';
import 'package:flutter_persistent_login/features/sign_up/presentation/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: buildTheme(),
      initialRoute: AppRoutes.root,
      routes: {
        AppRoutes.root: (context) => const AuthGate(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
      },
    );
  }
}

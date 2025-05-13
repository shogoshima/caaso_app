import 'package:caaso_app/services/plan_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/screens.dart';
import 'services/services.dart';
import 'models/models.dart';
import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ApiService.initialize('http://10.0.2.2:3001/go');
  AuthService();
  BenefitService();
  PlanService();
  PaymentService();
  SubscriptionService();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caaso App',
      theme: theme,
      home: MyHomePage(),
    );
  }
}

class AuthState extends ChangeNotifier {
  UserData? user;

  void saveUser(UserData userData) {
    user = userData;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto aguarda a primeira emissão, exibe um loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se houver um usuário logado, vai para AccountPage
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.emailVerified) {
          return const AccountPage();
        }

        // Caso contrário, vai para LoginPage
        return const LoginPage();
      },
    );
  }
}

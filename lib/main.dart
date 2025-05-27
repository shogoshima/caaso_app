import 'package:caaso_app/services/plan_service.dart';
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

  ApiService.initialize('https://codelab.icmc.usp.br/go');
  AuthService();
  BenefitService();
  PlanService();
  PaymentService();
  SubscriptionService();

  final authState = AuthState();
  await authState.loadUser();

  runApp(ChangeNotifierProvider.value(
    value: authState,
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
  bool isLoading = true;

  Future<void> loadUser() async {
    // ex.: busca de SharedPreferences, API, etc.
    try {
      user = await AuthService().getUser();
    } catch (e) {
      // Se falhar, deixa o usuário como null
      user = null;
    }
    isLoading = false;
    notifyListeners();
  }

  void saveUser(UserData userData) {
    user = userData;
    isLoading = false;
    notifyListeners();
  }

  void clearUser() {
    user = null;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // acessa o AuthState fornecido no main()
    final authState = context.watch<AuthState>();

    // enquanto ainda estiver “carregando” seu usuário
    if (authState.user == null && authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // se tiver usuário, vai pra AccountPage
    if (authState.user != null) {
      return const AccountPage();
    }

    // caso contrário, vai pra LoginPage
    return const LoginPage();
  }
}

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
  late UserData? user;

  void initUser(UserData userData) {
    user = userData;
  }

  void saveUser(UserData userData) {
    user = userData;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<UserData>? loggedUser;

  @override
  void initState() {
    super.initState();
    loggedUser = AuthService().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
        future: loggedUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.hasError) {
            return const LoginPage();
          }

          Provider.of<AuthState>(context, listen: false)
              .initUser(snapshot.data as UserData);
          return AccountPage();
        },
      ),
    );
  }
}

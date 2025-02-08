import 'screens/screens.dart';
import 'services/services.dart';
import 'models/models.dart';
import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

final apiClient = ApiService(
    'https://358d-2804-1b2-f144-6be7-d18c-3868-c68-a3e7.ngrok-free.app');
final AuthService authService = AuthService(apiClient);
final SubscriptionService subscriptionService = SubscriptionService(apiClient);
final PaymentService paymentService = PaymentService(apiClient);
final BenefitService benefitService = BenefitService(apiClient);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    loggedUser = authService.getUser();
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

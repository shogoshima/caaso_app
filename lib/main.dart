import 'package:caaso_app/models/user_data.dart';

import 'screens/screens.dart';
import 'services/services.dart';
import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

final apiClient = ApiService('http://10.0.2.2:3000');
final AuthService authService = AuthService(apiClient);
final SubscriptionService subscriptionService = SubscriptionService(apiClient);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
            image: AssetImage(
              'assets/logo.png',
            ),
            height: 100,
            width: 100,
            color: Theme.of(context).colorScheme.primary),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: const Center(child: LoginPage()),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ScanPage(),
            ));
          },
          icon: const Icon(Icons.camera),
          label: const Text('Escanear QR Code (Estabelecimentos)'),
          iconAlignment: IconAlignment.start,
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:caaso_app/main.dart';
import 'package:caaso_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caaso_app/screens/screens.dart';
import 'package:caaso_app/common/show_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context, listen: false);
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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: <Widget>[
                  Text('Sócio\nCAASO',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 30.0),
                  OutlinedButton(
                      onPressed: _isSigningIn
                          ? null
                          : () async {
                              if (_isSigningIn) return;
                              setState(() => _isSigningIn = true);

                              try {
                                User? user =
                                    await AuthService().signInWithGoogle();

                                if (user == null) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao realizar login'),
                                    ),
                                  );
                                  return;
                                }

                                // final emailDomain = user.email!.split('@')[1];
                                // if (emailDomain != 'usp.br' &&
                                //     user.email! != 't22110124@gmail.com') {
                                //   await AuthService().logoutWithGoogle();
                                //   if (!context.mounted) return;
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content: Text(
                                //           'Apenas e-mails USP são permitidos'),
                                //     ),
                                //   );
                                //   return;
                                // }

                                final idToken = await user.getIdToken();
                                final userData =
                                    await AuthService().login(idToken!);

                                log(userData.id);

                                auth.saveUser(userData);

                                if (!context.mounted) return;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AccountPage()),
                                );
                              } catch (e) {
                                log(e.toString());
                                showErrorDialog(context,
                                    "Erro ao realizar login. \nTente novamente.");
                              } finally {
                                setState(() => _isSigningIn = false);
                              }
                            },
                      child: const Text('Login com Google')),
                  TextButton(
                    onPressed: () {
                      showInfoDialog(
                          context,
                          'Para se tornar membro, basta logar com a sua conta '
                          'Google e realizar o pagamento da taxa '
                          'de inscrição.');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text('Como me tornar membro?'),
                  )
                ],
              ),
            ),
          ),
        ),
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

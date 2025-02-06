import 'package:caaso_app/main.dart';
import 'package:caaso_app/models/user_data.dart';
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              Text('SÓCIO CAASO',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30.0),
              OutlinedButton(
                  onPressed: () async {
                    try {
                      User? user = await authService.signInWithGoogle();

                      if (user == null) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao realizar login'),
                          ),
                        );
                        return;
                      }

                      final idToken = await user.getIdToken();
                      final userData = await authService.login(idToken!);

                      auth.saveUser(userData);

                      if (!context.mounted) return;
                      if (userData.nusp == "") {
                        showInputDialog(context, 'Bem Vindo!',
                            'Como é a sua primeira vez, pedimos que nos informe o seu número USP.',
                            (nusp) async {
                          final data = UserData(
                            id: user.uid,
                            nusp: nusp,
                            displayName: user.displayName,
                            photoUrl: user.photoURL,
                          );
                          try {
                            UserData newUserData =
                                await authService.create(data, idToken);
                            auth.saveUser(newUserData);
                            if (!context.mounted) return;
                          } catch (e) {
                            showErrorDialog(context, e.toString());
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login realizado com sucesso!'),
                            ),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AccountPage()),
                          );
                        });
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AccountPage()),
                        );
                      }
                    } catch (e) {
                      showErrorDialog(context, e.toString());
                    }
                  },
                  child: const Text('Login com Google')),
              TextButton(
                onPressed: () {
                  showInfoDialog(
                      context,
                      'Para se tornar membro, é necessário '
                      'ser aluno da USP e comparecer à sede da CAASO para '
                      'realizar o pagamento da taxa de inscrição.');
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
    );
  }
}

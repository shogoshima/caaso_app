import 'package:caaso_app/common/show_dialog.dart';
import 'package:flutter/material.dart';
import 'screens.dart';

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

  InputDecoration _buildInputDecoration(
      BuildContext context, String labelText) {
    return InputDecoration(
      border: OutlineInputBorder(),
      isCollapsed: true,
      contentPadding: EdgeInsets.all(10),
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      filled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              Text('SÓCIO CAASO',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(context, 'Número USP'),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Campo obrigatório';
                  // } else if (value.length != 8) {
                  //   return 'O número USP deve ter 8 dígitos';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: _buildInputDecoration(context, 'Senha'),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Campo obrigatório';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              OutlinedButton(
                onPressed: () async {
                  // Realiza a validação do formulário
                  if (_formKey.currentState!.validate()) {
                    // usernameController.clear();
                    // passwordController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login realizado com sucesso!'),
                      ),
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()),
                    );
                  }
                },
                child: const Text('Login'),
              ),
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

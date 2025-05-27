import 'package:caaso_app/main.dart';
import 'package:caaso_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:caaso_app/screens/screens.dart';
import 'package:caaso_app/common/show_dialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isSignUp = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    resetEmailController.dispose();
    super.dispose();
  }

  Widget _signUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: displayNameController,
            decoration: const InputDecoration(labelText: 'Nome Completo'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome completo';
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Senha'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua senha';
              }
              return null;
            },
          ),
          TextFormField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirmar Senha'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, confirme sua senha';
              }
              if (value != passwordController.text) {
                return 'As senhas não coincidem';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Senha'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua senha';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return FilledButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (_isLoading) return;
              setState(() => _isLoading = true);

              try {
                final userData = await AuthService().signInWithEmail(
                  email: emailController.text,
                  password: passwordController.text,
                );
                if (!mounted) return;
                // Verificação logo após o await

                final user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.emailVerified) {
                  // Caso o email não esteja verificado, manda verificar
                  await showResendVerificationDialog(
                    context,
                    'Seu email não foi verificado ainda. Por favor, verifique-o.',
                    () async {
                      await user.sendEmailVerification();
                      if (!mounted) return;
                      showInfoDialog(context, 'Email de verificação enviado!');
                    },
                  );
                  if (!mounted) return;
                  await AuthService().logout();
                } else {
                  // Caso esteja verificado, salva o usuário
                  Provider.of<AuthState>(context, listen: false)
                      .saveUser(userData);
                }
              } catch (e) {
                if (!mounted) return;
                showErrorDialog(context, e.toString());
                await AuthService().logout();
              }
              if (!mounted) return;
              setState(() => _isLoading = false);
            },
      child: const Text(
        'Entrar',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () async {
        if (_isLoading) return;
        setState(() => _isLoading = true);

        try {
          await showSendPasswordResetEmailDialog(
              context,
              'Insira seu email para recuperar sua senha',
              resetEmailController, () async {
            try {
              await AuthService().sendPasswordResetEmail(
                resetEmailController.text,
              );
              if (!mounted) return;
              showInfoDialog(
                  context, 'Email de recuperação enviado com sucesso!');
            } catch (e) {
              if (!mounted) return;
              showErrorDialog(context, e.toString());
            }
          });
        } catch (e) {
          if (!mounted) return;
          showErrorDialog(context, e.toString());
        }
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
      child: const Text('Esqueci minha senha'),
    );
  }

  Widget _buildSignUpButton() {
    return FilledButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (_isLoading) return;
              setState(() => _isLoading = true);

              try {
                if (_signUpFormKey.currentState!.validate()) {
                  await AuthService().signUpWithEmail(
                    displayName: displayNameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  if (!mounted) return;
                  showInfoDialog(
                      context,
                      'Um email de verificação foi enviado para o seu email. '
                      'Por favor, verifique seu email e clique no link de verificação.');
                  await AuthService().logout();
                }
              } catch (e) {
                if (!mounted) return;
                showErrorDialog(context, e.toString());
                await AuthService().logout();
              }
              if (!mounted) return;
              setState(() => _isLoading = false);
            },
      child: const Text(
        'Cadastrar',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (_isLoading) return;
              setState(() => _isLoading = true);

              try {
                final userData = await AuthService().signInWithGoogle();
                if (!mounted) return;
                Provider.of<AuthState>(context, listen: false)
                    .saveUser(userData);
              } catch (e) {
                if (!mounted) return;
                showErrorDialog(context, e.toString());
                await AuthService().logout();
                setState(() => _isLoading = false);
              }
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Prevent stretching to full width
          children: [
            Image.asset('assets/google.png', height: 24, width: 24),
            const SizedBox(width: 12),
            Text(
              'Logar com Google',
              style: TextStyle(
                fontSize: 14,
                color: _isLoading ? Colors.white38 : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                Text('Sócio\nCAASO',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 30.0),
                if (_isSignUp) _signUpForm() else _loginForm(),
                const SizedBox(height: 10.0),
                if (!_isSignUp) _buildForgotPasswordButton(),
                const SizedBox(height: 10.0),
                Text.rich(
                  TextSpan(
                    text: _isSignUp
                        ? 'Já possui uma conta? '
                        : 'Não possui uma conta? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: _isSignUp ? 'Faça login' : 'Cadastre-se',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() => _isSignUp = !_isSignUp);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                if (_isSignUp) _buildSignUpButton() else _buildLoginButton(),
                if (!_isSignUp)
                  Column(
                    children: [
                      const SizedBox(height: 20.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white30,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('ou'),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white30,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      _buildGoogleButton()
                    ],
                  ),
                const SizedBox(height: 30.0),
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
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: TextButton.icon(
          onPressed: _isLoading
              ? null
              : () {
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

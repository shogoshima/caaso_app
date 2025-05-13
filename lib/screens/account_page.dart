import 'package:caaso_app/main.dart';
import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<UserData>? loggedUser;

  @override
  void initState() {
    super.initState();
    final storedUser = Provider.of<AuthState>(context, listen: false).user;
    if (storedUser != null) {
      // já temos os dados na memória → não chama a API de novo
      loggedUser = Future.value(storedUser);
    } else {
      // busca na API (login já rolou antes)
      loggedUser = AuthService().getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          height: 100,
          width: 100,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutPage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<UserData?>(
              future: loggedUser,
              builder: (context, snapshot) {
                // 1) still loading
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  );
                }
                // 2) error
                if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar usuário:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                }
                final user = snapshot.data!;
                Provider.of<AuthState>(context, listen: false).saveUser(user);

                // got a user → show account info
                return Column(
                  children: [
                    Text(
                      'Olá, ${user.displayName.split(' ')[0]}!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user.isSubscribed
                          ? 'Sua assinatura é válida até\n'
                              '${user.expirationDate!.day}/'
                              '${user.expirationDate!.month}/'
                              '${user.expirationDate!.year}'
                          : 'Você não possui uma assinatura ativa',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 30),
                    OutlinedButton(
                      onPressed: user.isSubscribed
                          ? () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MembershipPage(
                                    token: user.token,
                                    name: user.displayName,
                                    type: user.type,
                                    profilePhotoUrl: user.photoUrl,
                                    validUntil: user.expirationDate,
                                  ),
                                ),
                              )
                          : null,
                      child: const Text('Carteirinha'),
                    ),
                    const SizedBox(height: 5),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BenefitsPage()),
                      ),
                      child: const Text('Benefícios'),
                    ),
                    const SizedBox(height: 5),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PaymentPage()),
                      ),
                      child: const Text('Pagamento'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: TextButton.icon(
          onPressed: () async {
            await AuthService().logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          iconAlignment: IconAlignment.start,
        ),
      ),
    );
  }
}

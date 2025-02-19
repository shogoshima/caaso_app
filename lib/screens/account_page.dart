import 'package:caaso_app/main.dart';
import 'package:caaso_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Consumer<AuthState>(
              builder: (context, auth, child) {
                if (auth.user == null) {
                  return const Text(
                      "Realize o login novamente para acessar esta página");
                }

                return Column(
                  children: [
                    Text('Olá, ${auth.user?.displayName?.split(' ')[0]}!',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 15.0),
                    Text(
                        auth.user?.isSubscribed == true
                            ? 'Sua assinatura é válida até \n ${auth.user?.expirationDate?.day}/${auth.user?.expirationDate?.month}/${auth.user?.expirationDate?.year}'
                            : 'Você não possui uma assinatura ativa',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 30.0),
                    OutlinedButton(
                        onPressed: auth.user?.isSubscribed == false
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => MembershipPage(
                                          name: auth.user?.displayName,
                                          userId: auth.user?.nusp,
                                          profilePhotoUrl: auth.user?.photoUrl,
                                          validUntil:
                                              auth.user?.expirationDate)),
                                );
                              },
                        child: Text('Carteirinha')),
                    const SizedBox(height: 5.0),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const BenefitsPage()),
                          );
                        },
                        child: Text('Benefícios')),
                    const SizedBox(height: 5.0),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const PaymentPage()),
                          );
                        },
                        child: Text('Pagamento')),
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
            await AuthService().logoutWithGoogle();
            if (!context.mounted) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          iconAlignment: IconAlignment.start,
        ),
      ),
    );
  }
}

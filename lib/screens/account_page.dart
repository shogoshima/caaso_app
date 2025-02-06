import 'package:caaso_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context, listen: false);
    if (auth.user == null) {
      return const LoginPage();
    }

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Olá, ${auth.user?.displayName?.split(' ')[0]}!',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 15.0),
                Text(auth.user?.isSubscribed == true
                    ? 'Sua assinatura é válida até ${auth.user?.expirationDate}'
                    : 'Você não possui uma assinatura ativa'),
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
                                      validUntil: auth.user?.expirationDate)),
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
                OutlinedButton(onPressed: () {}, child: Text('Pagamento')),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: TextButton.icon(
          onPressed: () async {
            await authService.logoutWithGoogle();
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          iconAlignment: IconAlignment.start,
        ),
      ),
    );
  }
}

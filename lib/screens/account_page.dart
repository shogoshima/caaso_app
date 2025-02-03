import 'package:flutter/material.dart';
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Olá, Yuri!',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 30.0),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const MembershipPage()),
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
                    child: Text('Seus benefícios')),
                OutlinedButton(onPressed: () {}, child: Text('Pagamento')),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: TextButton.icon(
          onPressed: () {
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

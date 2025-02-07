import 'package:flutter/material.dart';

class BenefitsPage extends StatelessWidget {
  const BenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benefícios'),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    tileColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    title: Text('Trem Bão $index',
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text('Descrição do benefício $index',
                        style: Theme.of(context).textTheme.bodySmall),
                    leading: Image(
                      image: const AssetImage('assets/trem_bao.png'),
                    ),
                  ),
                )),
      ),
    );
  }
}

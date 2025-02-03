import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: const AssetImage('assets/logo.png'),
          height: 100,
          width: 100,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  // Force minimum height to full available space
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Sócio',
                          style: Theme.of(context).textTheme.displaySmall),
                      Image(
                        image: const AssetImage('assets/profile.jpg'),
                        height: 250,
                        width: 200,
                      ),
                      Text(
                        'Yuri Donizete Claudino de Faria Santos',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Morador Aloja',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '13725587',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Card(
                        color: Theme.of(context).colorScheme.onSurface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: QrImageView(
                            data: '13725587',
                            version: QrVersions.auto,
                            size: 225.0,
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Ativo até 12/2025',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MembershipPage extends StatelessWidget {
  final String? name;
  final String? userId;
  final String? profilePhotoUrl;
  final DateTime? validUntil;

  const MembershipPage(
      {super.key,
      this.name,
      this.userId,
      this.profilePhotoUrl,
      this.validUntil});

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
                      Container(
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image(
                          image: Image.network(profilePhotoUrl ?? '').image,
                        ),
                      ),
                      Text(
                        name ?? 'Anônimo',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        userId ?? '00000000',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Card(
                        color: Theme.of(context).colorScheme.onSurface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: QrImageView(
                            data: userId ?? '00000000',
                            version: QrVersions.auto,
                            size: 250.0,
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Válido até ${validUntil?.day}/${validUntil?.month}/${validUntil?.year}',
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

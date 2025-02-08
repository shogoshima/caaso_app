import 'package:caaso_app/common/show_dialog.dart';
import 'package:caaso_app/main.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  GlobalKey key = GlobalKey();

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        ),
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: key,
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Número USP',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              (value.length != 7 && value.length != 8)) {
                            return 'Digite um número';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if ((key.currentState as FormState).validate()) {
                            try {
                              final data = await subscriptionService
                                  .getSubscriptionStatus(controller.text);

                              final isSubscribed = data['isSubscribed'];
                              final displayName = data['displayName'];
                              if (!context.mounted) return;
                              if (isSubscribed) {
                                showSuccessDialog(
                                  context,
                                  'Assinatura Válida\nUsuário: $displayName',
                                );
                              } else {
                                showErrorDialog(
                                  context,
                                  'Assinatura Inativa\nUsuário: $displayName',
                                );
                              }
                            } catch (e) {
                              showErrorDialog(
                                context,
                                'O número USP não foi encontrado',
                              );
                            }
                          }
                        },
                        child: const Text('Verificar')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

import 'dart:developer';

import 'package:caaso_app/common/show_dialog.dart';
import 'package:caaso_app/main.dart';
import 'package:caaso_app/common/currency_formatter.dart';
import 'package:caaso_app/models/prices.dart';
import 'package:caaso_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:caaso_app/models/models.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController planController = TextEditingController();
  UserType? selectedUser;
  PlanType? selectedPlan;

  Future<PaymentData>? currentPayment;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthState>(context, listen: false);
    if (auth.user != null && auth.user!.isSubscribed == false) {
      currentPayment = _refreshPaymentData();
    }
  }

  Future<PaymentData> _refreshPaymentData() async {
    log("Refreshing payment data");
    final newPayment = PaymentService().getPayment();
    setState(() {
      currentPayment = newPayment;
    });
    return await newPayment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: SafeArea(
        child: Center(
          child: Consumer<AuthState>(builder: (context, auth, child) {
            if (auth.user == null) {
              return const Text(
                  "Realize o login novamente para acessar esta página");
            }

            if (auth.user!.isSubscribed == true) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 100),
                  const Text('Plano Ativo!',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text(
                      'Você poderá renovar o seu \nplano após o término do atual',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              );
            }

            return FutureBuilder<PaymentData>(
                future: currentPayment,
                builder: (BuildContext context,
                    AsyncSnapshot<PaymentData> snapshot) {
                  List<Widget> children;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final paymentData = snapshot.data!;
                    if (paymentData.isPaid == true) {
                      return const CircularProgressIndicator();
                    }

                    children = <Widget>[
                      Card(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              QrImageView(
                                data: paymentData.qrCode!,
                                version: QrVersions.auto,
                                size: 250.0,
                                backgroundColor: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: paymentData.qrCode!));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'PIX copiado para a área de transferência'),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.copy),
                                    SizedBox(width: 10),
                                    Text('Copiar PIX'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(currencyFormatter.format(paymentData.amount),
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                          'Você possui até 24h para realizar o pagamento\n'
                          'Após o período, você poderá gerar um novo QR Code',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 20),
                      OutlinedButton(
                          onPressed: () async {
                            try {
                              final paymentData = await _refreshPaymentData();

                              if (paymentData.isPaid == true) {
                                final userData = await AuthService().getUser();
                                log("Fetched user data: ${userData.toJson()}");

                                if (context.mounted) {
                                  Provider.of<AuthState>(context, listen: false)
                                      .saveUser(userData);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pagamento aprovado!'),
                                    ),
                                  );
                                }
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pagamento pendente'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          },
                          child: const Text('Atualizar')),
                    ];
                  } else {
                    children = <Widget>[
                      Text('Selecione as opções:',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 20),
                      DropdownMenu<UserType>(
                        controller: userController,
                        label: const Text('Tipo de Usuário'),
                        onSelected: (UserType? user) {
                          setState(() {
                            selectedUser = user;
                          });
                        },
                        dropdownMenuEntries: UserType.values
                            .map<DropdownMenuEntry<UserType>>((UserType user) {
                          return DropdownMenuEntry<UserType>(
                            value: user,
                            label: user.value,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                      DropdownMenu<PlanType>(
                        controller: planController,
                        label: const Text('Plano'),
                        onSelected: (PlanType? plan) {
                          setState(() {
                            selectedPlan = plan;
                          });
                        },
                        dropdownMenuEntries: PlanType.values
                            .map<DropdownMenuEntry<PlanType>>((PlanType plan) {
                          return DropdownMenuEntry<PlanType>(
                              value: plan,
                              label: plan.value,
                              trailingIcon: selectedUser == null
                                  ? null
                                  : Text(
                                      currencyFormatter.format(
                                          getPrices(selectedUser)(plan)),
                                    ));
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      if (selectedUser != null && selectedPlan != null)
                        Column(
                          children: [
                            Text(
                                currencyFormatter.format(
                                    getPrices(selectedUser)(selectedPlan)),
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 20),
                            OutlinedButton(
                                onPressed: () async {
                                  try {
                                    await PaymentService().createPayment(
                                        selectedUser!, selectedPlan!);
                                    currentPayment = _refreshPaymentData();
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    showErrorDialog(context, e.toString());
                                  }
                                },
                                child: const Text('Gerar QR Code')),
                            const SizedBox(height: 10),
                            Text(
                                'O plano é sujeito a cancelamento caso \nvocê não seja do tipo especificado',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                    ];
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  );
                });
          }),
        ),
      ),
    );
  }
}

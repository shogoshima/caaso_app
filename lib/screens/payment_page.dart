import 'dart:developer';

import 'package:caaso_app/services/plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:caaso_app/common/currency_formatter.dart';
import 'package:caaso_app/common/show_dialog.dart';
import 'package:caaso_app/main.dart';
import 'package:caaso_app/models/models.dart';
import 'package:caaso_app/services/services.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoadingQRCode = false;

  final TextEditingController userController = TextEditingController();
  final TextEditingController planController = TextEditingController();
  String? selectedUser;
  String? selectedPlan;

  Future<PaymentData>? currentPayment;
  Future<Map<String, Map<String, double>>>? priceMap;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthState>(context, listen: false);
    if (auth.user != null && auth.user!.isSubscribed == false) {
      currentPayment = _refreshPaymentData();
    }
  }

  Future<PaymentData> _refreshPaymentData() async {
    log('Refreshing payment data');
    final newPayment = PaymentService().getPayment();
    final plans = PlanService().fetchPlans();
    setState(() {
      currentPayment = newPayment;
      priceMap = plans;
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
          child: Consumer<AuthState>(
            builder: (context, auth, child) {
              if (auth.user == null) {
                return const Text(
                  'Realize o login novamente para acessar esta página',
                );
              }

              if (auth.user!.isSubscribed) {
                return _buildActivePlanUI();
              }

              return FutureBuilder<PaymentData>(
                future: currentPayment,
                builder: (context, snapshot) {
                  if (currentPayment == null) {
                    return _buildPlanSelectionUI();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final paymentData = snapshot.data!;
                    if (!paymentData.isPaid!) {
                      return _buildQrCodeUI(paymentData);
                    }

                    return const CircularProgressIndicator();
                  }

                  // Caso não haja dados ainda, exibe seleção de plano
                  return _buildPlanSelectionUI();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivePlanUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 100,
        ),
        SizedBox(height: 16),
        Text(
          'Plano Ativo!',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Você poderá renovar o seu plano\n após o término do atual',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeUI(PaymentData paymentData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: paymentData.qrCode ?? '',
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: paymentData.qrCode ?? ''),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('PIX copiado para a área de transferência'),
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
                Text(
                  currencyFormatter.format(paymentData.amount),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Você possui até 24h para realizar o pagamento',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {
            setState(() {
              currentPayment = null;
              selectedUser = null;
              selectedPlan = null;
              userController.clear();
              planController.clear();
            });
          },
          child: const Text('Recriar QR Code'),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () async {
            try {
              final updated = await _refreshPaymentData();
              if (updated.isPaid!) {
                final userData = await AuthService().getUser();
                if (!mounted) return;
                Provider.of<AuthState>(context, listen: false)
                    .saveUser(userData);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pagamento aprovado!')),
                );
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pagamento pendente')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Text('Atualizar'),
        ),
      ],
    );
  }

  Widget _buildPlanSelectionUI() {
    return FutureBuilder<Map<String, Map<String, double>>>(
      future: priceMap,
      builder: (context, snapMap) {
        final isLoadingMap = snapMap.connectionState == ConnectionState.waiting;
        final hasMapError = snapMap.hasError || !snapMap.hasData;
        // Enquanto carrega ou deu erro, exibe loading ou mensagem simples:
        if (isLoadingMap) {
          return const CircularProgressIndicator();
        }
        if (hasMapError) {
          return const Text('Erro ao carregar preços');
        }

        // Temos o mapa de preços aqui:
        final prices = snapMap.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecione as opções:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            // Dropdown de usuário (string)
            DropdownMenu<String>(
              controller: userController,
              label: const Text('Usuário'),
              onSelected: (user) {
                setState(() {
                  selectedUser = user;
                  // reseta plano ao mudar usuário
                  selectedPlan = null;
                  planController.clear();
                });
              },
              dropdownMenuEntries:
                  ['Alojamento', 'Graduação', 'Pós-Graduação', 'Outros']
                      .map((user) => DropdownMenuEntry<String>(
                            value: user,
                            label: user,
                          ))
                      .toList(),
            ),
            const SizedBox(height: 15),
            // Dropdown de plano (string)
            DropdownMenu<String>(
              controller: planController,
              enabled: selectedUser != null,
              label: const Text('Plano'),
              onSelected: (plan) {
                setState(() {
                  selectedPlan = plan;
                });
              },
              dropdownMenuEntries: ['Mensal', 'Anual'].map((plan) {
                // cria a função lookup só se usuário já estiver selecionado
                final lookup = selectedUser == null
                    ? (_) => null
                    : getPrices(selectedUser!, prices);
                final price = lookup(plan);
                return DropdownMenuEntry<String>(
                  value: plan,
                  label: plan,
                  trailingIcon: price == null
                      ? null
                      : Text(currencyFormatter.format(price)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedUser != null && selectedPlan != null) ...[
              // mostra o preço grande
              Text(
                currencyFormatter.format(
                  getPrices(selectedUser!, prices)(selectedPlan!),
                ),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _isLoadingQRCode
                    ? null
                    : () async {
                        if (_isLoadingQRCode) return;
                        setState(() => _isLoadingQRCode = true);
                        try {
                          await PaymentService().createPayment(
                            selectedUser!,
                            selectedPlan!,
                          );
                          setState(() {
                            currentPayment = _refreshPaymentData();
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          showErrorDialog(context, e.toString());
                        } finally {
                          setState(() => _isLoadingQRCode = false);
                        }
                      },
                child: const Text('Criar QR Code'),
              ),
              const SizedBox(height: 10),
              Text(
                'O plano é sujeito a cancelamento caso \nvocê não seja do tipo especificado',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ],
        );
      },
    );
  }
}

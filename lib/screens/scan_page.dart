import 'dart:developer';

import 'package:caaso_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:caaso_app/widgets/widgets.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? _barcode;
  final MobileScannerController _controller = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates);

  bool? isSubscribed;
  String? displayName;
  String? photoUrl;
  String? type;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Nenhum QR Code detectado.',
        style: TextStyle(color: Colors.white, fontSize: 20),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          foregroundImage: Image.network(photoUrl ?? '').image,
          radius: 30,
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          '$displayName',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          '$type',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(
          height: 20,
        ),
        isSubscribed == true
            ? Icon(Icons.check_circle, color: Colors.green, size: 50)
            : Icon(Icons.close_rounded, color: Colors.red, size: 50),
        isSubscribed == true
            ? Text('Assinatura válida',
                style: TextStyle(color: Colors.green, fontSize: 20))
            : Text('Assinatura inválida',
                style: TextStyle(color: Colors.red, fontSize: 20)),
      ],
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (!mounted) return;

    // if no barcode detected, do nothing
    if (barcodes.barcodes.isEmpty) return;

    // if barcode is the same, do nothing
    final currentBarcode = barcodes.barcodes.first;
    if (_barcode == currentBarcode) return;

    try {
      log('Barcode detected: ${currentBarcode.displayValue}');
      final data = await SubscriptionService()
          .getSubscriptionStatus(currentBarcode.displayValue!);
      setState(() {
        _barcode = currentBarcode;
        isSubscribed = data['isSubscribed'];
        displayName = data['displayName'];
        photoUrl = data['photoUrl'];
        type = data['type'];
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar informações do QR Code.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          child: Stack(
            children: [
              Positioned.fill(
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _handleBarcode,
                  onDetectError: (error, stackTrace) => ScannerErrorWidget(
                      error: error as MobileScannerException),
                ),
              ),
              const OverlayWithHole(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      height: size.height * 0.30,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(child: _buildBarcode(_barcode)),
                    ),
                  )),
            ],
          ),
        ));
  }
}

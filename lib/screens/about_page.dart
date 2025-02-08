import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 10;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Caaso App',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Feito com ❤️ (e 5 dias) por',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              particleDrag: 0.025, // apply drag to the confetti
              emissionFrequency: 0.01, // how often it should emit
              numberOfParticles: 100, // number of particles to emit

              confettiController: _controller,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
                Colors.lightGreen
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
          GestureDetector(
            onTap: () {
              _controller.play();
            },
            child: Text(
              'Shogo Shima',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(SimpleIcons.github),
                onPressed: () async {
                  await _launchUrl('https://github.com/shogoshima');
                },
              ),
              IconButton(
                icon: const Icon(SimpleIcons.linkedin),
                onPressed: () async {
                  await _launchUrl('https://linkedin.com/in/shogo-shima');
                },
              ),
              IconButton(
                icon: Image.asset("assets/codelab.png",
                    width: 35,
                    height: 35,
                    color: Theme.of(context).colorScheme.onSurface),
                onPressed: () async {
                  await _launchUrl('https://codelab.icmc.usp.br/');
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Text('Caso encontre erros, reporte para o email:',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 5.0),
          GestureDetector(
            onTap: () async {
              await _launchUrl('mailto:shogoshima@usp.br');
            },
            child: Text('shogoshima@usp.br',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 30.0),
          Text(
            'Versão 1.0.0',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10.0),
          Text(
            '© 2025 Codelab',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

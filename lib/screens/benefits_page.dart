import 'package:caaso_app/main.dart';
import 'package:caaso_app/models/models.dart';
import 'package:flutter/material.dart';

class BenefitsPage extends StatefulWidget {
  const BenefitsPage({super.key});

  @override
  State<BenefitsPage> createState() => _BenefitsPageState();
}

class _BenefitsPageState extends State<BenefitsPage> {
  Future<List<BenefitData>>? benefits;

  @override
  void initState() {
    super.initState();
    fetchBenefits();
  }

  Future<void> fetchBenefits() async {
    benefits = benefitService.fetchBenefits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benefícios'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<BenefitData>>(
          future: benefits,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text('Erro ao carregar benefícios'),
              );
            }

            List<BenefitData> benefits = snapshot.data!;
            return ListView.builder(
                itemCount: benefits.length,
                itemBuilder: (context, index) => Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.network(
                                  benefits[index].photoUrl,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    benefits[index].title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                subtitle: Text(
                                  benefits[index].description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
          },
        ),
      ),
    );
  }
}

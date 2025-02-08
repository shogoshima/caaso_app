import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Erro', style: TextStyle(color: Colors.red)),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showSuccessDialog(BuildContext context, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Icon(Icons.check_circle, color: Colors.green, size: 100),
        content: Text(content, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showInfoDialog(BuildContext context, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:
            Text('Informação', style: Theme.of(context).textTheme.titleLarge),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showInputDialog(BuildContext context, String title, String content,
    Function(String) onConfirm) async {
  GlobalKey key = GlobalKey();
  final TextEditingController controller = TextEditingController();
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(content),
            Form(
              key: key,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Digite aqui',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      (value.length != 7 && value.length != 8)) {
                    return 'Por favor, digite um número USP válido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Distribute space between buttons
            children: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () async {
                  if ((key.currentState as FormState).validate()) {
                    Navigator.of(context).pop(); // Close the dialog
                    onConfirm(controller.text); // Trigger the callback
                  }
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

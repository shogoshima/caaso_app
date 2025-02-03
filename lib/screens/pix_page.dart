// import 'package:flutter/material.dart';
// import 'package:pix_flutter/pix_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var query;

//   /// As informações solicitadas a seguir estão disponíveis no seu PSP ou instituição financeira.
//   PixFlutter pixFlutter = PixFlutter(
//       api: Api(
//           baseUrl: 'https://api.hm.bb.com.br/pix/v1',
//           authUrl: 'https://oauth.hm.bb.com.br/oauth/token',
//           certificate:
//               'Basic ZXlKcFpDSTZJbUU1TW1Jek0yWXRNVGMxTmkwMElpd2lZMjlrYVdkdlVIVmliR2xqWVdSdmNpSTZNQ3dpWTI5a2FXZHZVMjltZEhkaGNtVWlPakUzTURjMUxDSnpaWEYxWlc1amFXRnNTVzV6ZEdGc1lXTmhieUk2TVgwOmV5SnBaQ0k2SWpSa09XUTBPREl0TlRVNU5DMDBaVE5sTFRnd01UY3RZbVZsT1RrME5EWmxObUpsWkROaU9HTXdOV1F0SWl3aVkyOWthV2R2VUhWaWJHbGpZV1J2Y2lJNk1Dd2lZMjlrYVdkdlUyOW1kSGRoY21VaU9qRTNNRGMxTENKelpYRjFaVzVqYVdGc1NXNXpkR0ZzWVdOaGJ5STZNU3dpYzJWeGRXVnVZMmxoYkVOeVpXUmxibU5wWVd3aU9qRXNJbUZ0WW1sbGJuUmxJam9pYUc5dGIyeHZaMkZqWVc4aUxDSnBZWFFpT2pFMk1qTTFNRGt4TWpJeE16Tjk=',
//           appKey: 'd27b377903ffabc01368e17d80050c56b931a5bf',
//           permissions: [
//             PixPermissions.cobRead,
//             PixPermissions.cobWrite,
//             PixPermissions.pixRead,
//             PixPermissions.pixWrite
//           ], // Lista das permissoes, use PixPermissions,
//           isBancoDoBrasil: true // Use true se estiver usando API do BB,
//           // Se voce estiver usando um certificado P12, utilize desta forma:
//           // certificatePath:
//           // e inclua o destino para o arquivo ;)
//           ),

//       // Essas informações a seguir somente são necessárias se você deseja utilizar o QR Code Estático
//       payload: Payload(
//           pixKey: '97fe9c15-5d14-4901-9c0a-45325d92ba2c',

//           /// Há um erro no API que impede o uso de descrição, ela não será inserida. Assim que o bug for consertado, o código voltará ao funcionamento completo.
//           description: 'Compra de teste',
//           merchantName: 'Shogo Shima',
//           merchantCity: 'São Carlos',
//           txid:
//               'shogoshima@usp.br12675145', // Até 25 caracteres para o QR Code estático
//           amount: '1'));

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Container(
//                   height: 255,
//                   width: 255,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.black, width: 5),
//                   ),
//                   child: query != null
//                       ? QrImageView(
//                           data: query!,
//                           version: QrVersions.auto,
//                           size: 250.0,
//                         )
//                       : Center(
//                           child: Text(
//                             'Crie uma compra para que o QR apareça aqui',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 16),
//                           ),
//                         )),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 8.0),
//             child: Text(
//               'QR Code Estático',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               TextButton(
//                   onPressed: () async {
//                     query = pixFlutter.getQRCode();
//                     setState(() {});
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.lightGreenAccent,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(11.0),
//                       child: Center(
//                         child: Text(
//                           'Criar',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 8.0),
//             child: Text(
//               'Cobrança Imediata',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               TextButton(
//                   onPressed: () async {
//                     var request = {
//                       "calendario": {"expiracao": "36000"},
//                       "devedor": {"cpf": "02247279236", "nome": "Shogo Shima"},
//                       "valor": {"original": "1"},
//                       "chave": "5511916444183",
//                       "solicitacaoPagador": "Cobrança dos serviços prestados."
//                     };

//                     query = await pixFlutter.createCobTxid(
//                         txid: "dgkjsdhgkjshddgsdggjshogo", request: request);

//                     var payloadDinamico = PixFlutter(
//                         payload: Payload(
//                       merchantName: "Shogo Shima",
//                       merchantCity: "São Carlos",
//                       txid: "uFtsUPrY1dVV8oLshK1DLsRbYrbZ9UfRouW",
//                       url:
//                           "qrcodepix-h.bb.com.br/pix/v2/a1bfb8af-3485-4509-8b75-bfc6b7749de9",
//                       isUniquePayment: true,
//                     ));

//                     query = payloadDinamico.getQRCode();

//                     setState(() {});
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.lightGreenAccent,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(11.0),
//                       child: Center(
//                         child: Text(
//                           'Criar',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )),
//               TextButton(
//                   onPressed: () async {
//                     var request = {
//                       "loc": {"id": "7768"},
//                       "devedor": {
//                         "cpf": "12345678909",
//                         "nome": "Francisco da Silva"
//                       },
//                       "valor": {"original": "123.45"},
//                       "solicitacaoPagador": "Cobrança dos serviços prestados."
//                     };

//                     query = await pixFlutter.reviewCob(
//                         request: request,
//                         txid: 'uFtsUPrY1dVV8oLshK1DLsRbYrbZ9UfRouW');

//                     query = query['location'];

//                     setState(() {});
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.orange,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(11.0),
//                       child: Center(
//                         child: Text(
//                           'Revisar',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )),
//               TextButton(
//                   onPressed: () {
//                     pixFlutter.checkCob(
//                         txid: 'uFtsUPrY1dVV8oLshK1DLsRbYrbZ9UfRouW');
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(11.0),
//                       child: Center(
//                         child: Text(
//                           'Consultar',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )),
//               TextButton(
//                   onPressed: () {
//                     // Atenção! Siga o padrao RFC 3339 para a data

//                     pixFlutter.checkCobList(
//                         queryParameters:
//                             'inicio=2021-05-10T00:00:00Z&fim=2021-08-14T23:59:59Z');
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.brown,
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(11.0),
//                       child: Center(
//                         child: Text(
//                           'Consultar lista',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )),
//             ],
//           ),
//         ],
//       )),
//     );
//   }
// }

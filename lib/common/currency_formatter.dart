import 'package:intl/intl.dart';

// Create a NumberFormat instance for Brazilian Real (R$)
NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'pt_BR', // Brazilian locale
  symbol: 'R\$', // Currency symbol
  decimalDigits: 2, // Number of decimal places
);

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/card_controller.dart';
import 'views/home_view.dart';
import 'views/add_card_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardController(),
      child: MaterialApp(
        title: 'Ranking de Cartas Pokémon',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeView(),
          '/addCard': (context) => AddCardView(
            controller: context.read<CardController>(),
          ),
        },
      ),
    );
  }
}

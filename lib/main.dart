import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';

void main() async {
  // Garante a inicialização dos bindings do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await DatabaseService.init();

  runApp(const ChurrasControlApp());
}

class ChurrasControlApp extends StatelessWidget {
  const ChurrasControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChurrasControl 🥩',
      debugShowCheckedModeBanner: false,

      // Configuração do Tema Visual para Churrasco (Tons de Vermelho e Brasa)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C), // Vermelho Escuro
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}

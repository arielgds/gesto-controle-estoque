import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';

void main() async {
  // Garante a inicialização dos bindings do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o armazenamento local (Hive)
  await DatabaseService.init();

  runApp(const MeuEstoqueApp());
}

class MeuEstoqueApp extends StatelessWidget {
  const MeuEstoqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Estoque',
      debugShowCheckedModeBanner: false,

      // Configuração do Tema Visual do Aplicativo
      theme: ThemeData(
        useMaterial3: true,
        // Define uma cor semente (Rosa/Vinho elegante para o segmento de lingerie)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD81B60),
          brightness: Brightness.light,
        ),
        // Customização padrão para as barras de navegação do app
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD81B60),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),

      // Define a tela inicial do aplicativo
      home: const HomeScreen(),
    );
  }
}

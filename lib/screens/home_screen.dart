import 'package:flutter/material.dart';
import 'package:statefulclickcounter/screens/cadastro_screen.dart';
import 'package:statefulclickcounter/screens/lista_screen.dart';
import '../services/database_service.dart';
import '../models/produto_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _totalPecas = 0;
  int _estoqueBaixo = 0;

  @override
  void initState() {
    super.initState();
    _carregarResumo();
  }

  Future<void> _carregarResumo() async {
    final List<ProdutoModel> produtos = await DatabaseService.buscarProdutos();
    double total = 0;
    int baixo = 0;

    for (var p in produtos) {
      total += p.quantidade;
      if (p.quantidade <= 2) baixo++;
    }

    setState(() {
      _totalPecas = total;
      _estoqueBaixo = baixo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesto - Controle de Estoque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarResumo,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá! 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Confira como está seu estoque hoje:'),
            const SizedBox(height: 20),

            // Grid de Resumo (Dashboard Real)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                    'Total Peças', 
                    _totalPecas % 1 == 0 ? _totalPecas.toInt().toString() : _totalPecas.toStringAsFixed(1), 
                    Icons.inventory_2, 
                    Colors.blue),
                _buildDashboardCard('Estoque Baixo', '$_estoqueBaixo',
                    Icons.warning_amber_rounded, Colors.orange),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Ações Rápidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Botões de Ação
            ListTile(
              leading: const Icon(Icons.list_alt, color: Color(0xFFD81B60)),
              title: const Text('Ver Estoque Completo'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListaScreen()),
                );
                _carregarResumo(); // Atualiza ao voltar
              },
            ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(Icons.add_box_outlined, color: Color(0xFFD81B60)),
              title: const Text('Cadastrar Novo Produto'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroScreen()),
                );
                if (result == true) _carregarResumo();
              },
            ),
          ],
        ),
      ),
      // Botão Flutuante para Adicionar Rápido
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroScreen()),
          );
          if (result == true) _carregarResumo();
        },
        backgroundColor: const Color(0xFFD81B60),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Função auxiliar para criar os cards do Dashboard
  Widget _buildDashboardCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 10),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

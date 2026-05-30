import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/database_service.dart';
import 'cadastro_screen.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<ProdutoModel> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarEstoque();
  }

  Future<void> _carregarEstoque() async {
    setState(() => _carregando = true);
    final dados = await DatabaseService.buscarProdutos();
    setState(() {
      _produtos = dados;
      _carregando = false;
    });
  }

  void _alterarQuantidade(ProdutoModel produto, double diferenca) async {
    double novaQtd = produto.quantidade + diferenca;
    if (novaQtd < 0) novaQtd = 0;

    final produtoAtualizado = produto.copyWith(quantidade: novaQtd);
    await DatabaseService.salvarProduto(produtoAtualizado);
    _carregarEstoque();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque do Churrasco 🥩'),
        backgroundColor: Colors.red[900],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: (context, index) {
                final produto = _produtos[index];
                // Alerta crítico: Menos de 2kg ou 2 unidades
                final ehEstoqueBaixo = produto.quantidade <= 2;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${produto.categoria} | R\$ ${produto.precoVenda.toStringAsFixed(2)} / ${produto.unidadeMedida}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _alterarQuantidade(produto, -0.5),
                        ),
                        Text(
                          '${produto.quantidade.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => _alterarQuantidade(produto, 0.5),
                        ),
                      ],
                    ),
                    tileColor: ehEstoqueBaixo ? Colors.orange[50] : null,
                  ),
                );
              },
            ),
    );
  }
}

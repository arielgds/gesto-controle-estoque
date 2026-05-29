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

  // Busca os dados atualizados do armazenamento local
  Future<void> _carregarEstoque() async {
    setState(() => _carregando = true);
    final dados = await DatabaseService.buscarProdutos();
    setState(() {
      _produtos = dados;
      _carregando = false;
    });
  }

  // Altera a quantidade de um produto rapidamente (+ ou -)
  void _alterarQuantidade(ProdutoModel produto, int diferenca) async {
    int novaQtd = produto.quantidade + diferenca;

    // Impede que o estoque fique negativo
    if (novaQtd < 0) return;

    final produtoAtualizado = produto.copyWith(quantidade: novaQtd);
    await DatabaseService.salvarProduto(produtoAtualizado);
    _carregarEstoque(); // Atualiza a tela com o novo valor
  }

  // Deleta o produto com confirmação
  void _deletarProduto(String id) async {
    await DatabaseService.excluirProduto(id);
    _carregarEstoque();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto removido do estoque.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque Disponível'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarEstoque,
          )
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _produtos.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto cadastrado ainda! 👙',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos[index];
                    final ehEstoqueBaixo = produto.quantidade <= 2;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: ehEstoqueBaixo
                            ? const BorderSide(color: Colors.orange, width: 1.5)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          produto.nome,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                                'Tam: ${produto.tamanho} | Cor: ${produto.cor}'),
                            Text(
                              'R\$ ${produto.precoVenda.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Color(0xFFD81B60),
                                  fontWeight: FontWeight.bold),
                            ),
                            if (ehEstoqueBaixo)
                              const Text(
                                '⚠️ Estoque crítico!',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        // Botões de controle de estoque (+ e -) no lado direito
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () => _alterarQuantidade(produto, -1),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${produto.quantidade}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                              onPressed: () => _alterarQuantidade(produto, 1),
                            ),
                          ],
                        ),
                        // Clique longo abre a tela de edição ou exclusão
                        onLongPress: () {
                          _mostrarOpcoes(context, produto);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  // Menu flutuante para Editar ou Excluir ao segurar o card
  void _mostrarOpcoes(BuildContext context, ProdutoModel produto) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar Produto'),
                onTap: () async {
                  Navigator.pop(context);
                  final alterou = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CadastroScreen(produtoParaEditar: produto)),
                  );
                  if (alterou == true) _carregarEstoque();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir do Estoque'),
                onTap: () {
                  Navigator.pop(context);
                  _deletarProduto(produto.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

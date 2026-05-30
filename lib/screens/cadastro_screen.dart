import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/database_service.dart';

class CadastroScreen extends StatefulWidget {
  final ProdutoModel? produtoParaEditar;

  const CadastroScreen({super.key, this.produtoParaEditar});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();

  final List<String> _unidades = ['Kg', 'g', 'Unidade', 'Saco', 'Litro', 'Pack'];
  final List<String> _categorias = [
    'Carnes',
    'Bebidas',
    'Acompanhamentos',
    'Carvão/Acessórios',
    'Hortifruti'
  ];

  String? _unidadeSelecionada;
  String? _categoriaSelecionada;
  bool _estaSalvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.produtoParaEditar != null) {
      _nomeController.text = widget.produtoParaEditar!.nome;
      _precoController.text = widget.produtoParaEditar!.precoVenda.toString();
      _quantidadeController.text = widget.produtoParaEditar!.quantidade.toString();
      _unidadeSelecionada = widget.produtoParaEditar!.unidadeMedida;
      _categoriaSelecionada = widget.produtoParaEditar!.categoria;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      if (_unidadeSelecionada == null || _categoriaSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione a unidade e a categoria!')),
        );
        return;
      }

      setState(() => _estaSalvando = true);

      final produto = ProdutoModel(
        id: widget.produtoParaEditar?.id,
        nome: _nomeController.text.trim(),
        unidadeMedida: _unidadeSelecionada!,
        categoria: _categoriaSelecionada!,
        quantidade: double.parse(_quantidadeController.text.replaceAll(',', '.')),
        precoVenda: double.parse(_precoController.text.replaceAll(',', '.')),
      );

      await DatabaseService.salvarProduto(produto);

      setState(() => _estaSalvando = false);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Item - Churras')),
      body: _estaSalvando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Item (Ex: Picanha, Carvão)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.kebab_dining),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Insira o nome' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _categoriaSelecionada,
                      decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                      items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _categoriaSelecionada = v),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _unidadeSelecionada,
                      decoration: const InputDecoration(labelText: 'Unidade de Medida', border: OutlineInputBorder()),
                      items: _unidades.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (v) => setState(() => _unidadeSelecionada = v),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _precoController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Preço (R\$)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _quantidadeController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Qtd Estoque', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900], // Cor de carne/churrasco
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('SALVAR NO ESTOQUE', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

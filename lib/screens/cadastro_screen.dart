import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/database_service.dart';

class CadastroScreen extends StatefulWidget {
  final ProdutoModel?
      produtoParaEditar; // Se vier preenchido, o app entra em modo de edição

  const CadastroScreen({super.key, this.produtoParaEditar});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // Chave global para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();

  // Opções pré-definidas para facilitar o uso no nicho de lingerie
  final List<String> _tamanhos = [
    'P',
    'M',
    'G',
    'GG',
    'XG',
    'Único',
    '40',
    '42',
    '44',
    '46'
  ];
  final List<String> _cores = [
    'Preto',
    'Branco',
    'Vermelho',
    'Romance (Rosa)',
    'Bege/Nude',
    'Azul Marinho',
    'Cereja'
  ];

  String? _tamanhoSelecionado;
  String? _corSelecionada;
  bool _estaSalvando = false;

  @override
  void initState() {
    super.initState();
    // Se estivermos editando um produto, preenchemos os campos com os dados existentes
    if (widget.produtoParaEditar != null) {
      _nomeController.text = widget.produtoParaEditar!.nome;
      _precoController.text = widget.produtoParaEditar!.precoVenda.toString();
      _quantidadeController.text =
          widget.produtoParaEditar!.quantidade.toString();
      _tamanhoSelecionado = widget.produtoParaEditar!.tamanho;
      _corSelecionada = widget.produtoParaEditar!.cor;
    } else {
      _quantidadeController.text = '1'; // Valor padrão inicial
    }
  }

  @override
  void dispose() {
    // Boa prática de Arquitetura: Limpar os controladores da memória RAM quando a tela fechar
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  // Função que valida o formulário e salva os dados no hardware
  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      if (_tamanhoSelecionado == null || _corSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, selecione o tamanho e a cor!')),
        );
        return;
      }

      setState(() => _estaSalvando = true);

      // Monta o objeto com os dados da tela
      final produto = ProdutoModel(
        id: widget.produtoParaEditar?.id, // Mantém o ID se for edição
        nome: _nomeController.text.trim(),
        tamanho: _tamanhoSelecionado!,
        cor: _corSelecionada!,
        quantidade: int.parse(_quantidadeController.text),
        precoVenda: double.parse(_precoController.text.replaceAll(',', '.')),
      );

      // Chama o nosso serviço de banco de dados local
      await DatabaseService.salvarProduto(produto);

      setState(() => _estaSalvando = false);

      // Avisa o usuário e volta para a tela anterior
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.produtoParaEditar == null
                  ? 'Produto cadastrado!'
                  : 'Produto atualizado!')),
        );
        Navigator.pop(
            context, true); // Retorna 'true' para indicar que o estoque mudou
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ehEdicao = widget.produtoParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(ehEdicao ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: _estaSalvando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo Nome do Produto
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Produto / Modelo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Insira o nome do modelo'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown de Tamanho
                    DropdownButtonFormField<String>(
                      value: _tamanhoSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Tamanho',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      items: _tamanhos
                          .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _tamanhoSelecionado = value),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown de Cor
                    DropdownButtonFormField<String>(
                      value: _corSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Cor Principal',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.color_lens_outlined),
                      ),
                      items: _cores
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _corSelecionada = value),
                    ),
                    const SizedBox(height: 16),

                    // Linha com Preço e Quantidade
                    Row(
                      children: [
                        // Campo Preço
                        Expanded(
                          child: TextFormField(
                            controller: _precoController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Preço de Venda (R\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Insira o preço'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Campo Quantidade
                        Expanded(
                          child: TextFormField(
                            controller: _quantidadeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Qtd Inicial',
                              border: OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.production_quantity_limits),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Insira a qtd';
                              if (int.tryParse(value) == null)
                                return 'Apenas números';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Botão Salvar
                    ElevatedButton.icon(
                      onPressed: _salvar,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                          ehEdicao ? 'SALVAR ALTERAÇÕES' : 'CADASTRAR PRODUTO',
                          style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD81B60),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

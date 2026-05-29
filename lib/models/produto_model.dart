class ProdutoModel {
  final String? id; // O ID pode ser nulo antes de ser salvo no banco
  final String nome;
  final String tamanho; // Ex: P, M, G, GG, 42, 44
  final String cor; // Ex: Preto, Vermelho, Romance
  final int quantidade;
  final double precoVenda;

  ProdutoModel({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.cor,
    required this.quantidade,
    required this.precoVenda,
  });

  // Método auxiliar para criar uma cópia do produto alterando apenas alguns dados
  // Muito útil para quando formos dar "+" ou "-" na quantidade do estoque
  ProdutoModel copyWith({
    String? id,
    String? nome,
    String? tamanho,
    String? cor,
    int? quantidade,
    double? precoVenda,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tamanho: tamanho ?? this.tamanho,
      cor: cor ?? this.cor,
      quantidade: quantidade ?? this.quantidade,
      precoVenda: precoVenda ?? this.precoVenda,
    );
  }

  // CONVERSÃO: Transforma o Objeto do código em um Mapa (JSON) para salvar no celular
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'cor': cor,
      'quantidade': quantidade,
      'precoVenda': precoVenda,
    };
  }

  // CONVERSÃO: Pega o Mapa (JSON) do armazenamento local e reconstrói o Objeto no Flutter
  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'] as String?,
      nome: map['nome'] as String,
      tamanho: map['tamanho'] as String,
      cor: map['cor'] as String,
      quantidade: map['quantidade'] as int,
      precoVenda: (map['precoVenda'] as num).toDouble(),
    );
  }
}

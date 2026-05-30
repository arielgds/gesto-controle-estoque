class ProdutoModel {
  final String? id;
  final String nome;
  final String unidadeMedida; // Ex: Kg, g, Unidade, Saco
  final String categoria; // Ex: Carne, Bebida, Acompanhamento
  final double quantidade; // Mudamos para double para suportar 1.5kg
  final double precoVenda;

  ProdutoModel({
    this.id,
    required this.nome,
    required this.unidadeMedida,
    required this.categoria,
    required this.quantidade,
    required this.precoVenda,
  });

  ProdutoModel copyWith({
    String? id,
    String? nome,
    String? unidadeMedida,
    String? categoria,
    double? quantidade,
    double? precoVenda,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      unidadeMedida: unidadeMedida ?? this.unidadeMedida,
      categoria: categoria ?? this.categoria,
      quantidade: quantidade ?? this.quantidade,
      precoVenda: precoVenda ?? this.precoVenda,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'unidadeMedida': unidadeMedida,
      'categoria': categoria,
      'quantidade': quantidade,
      'precoVenda': precoVenda,
    };
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'] as String?,
      nome: map['nome'] as String,
      unidadeMedida: map['unidadeMedida'] as String,
      categoria: map['categoria'] as String,
      quantidade: (map['quantidade'] as num).toDouble(),
      precoVenda: (map['precoVenda'] as num).toDouble(),
    );
  }
}

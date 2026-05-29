
import 'package:hive_flutter/hive_flutter.dart';
import '../models/produto_model.dart';

class DatabaseService {
  static const String _boxName = 'estoque_box';

  // Inicializa o Hive (será chamado no main.dart)
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  // 1. SALVAR / ADICIONAR PRODUTO
  static Future<void> salvarProduto(ProdutoModel novoProduto) async {
    var box = Hive.box(_boxName);
    
    // Gera um ID se não existir
    String idFinal = novoProduto.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    ProdutoModel produtoParaSalvar = novoProduto.copyWith(id: idFinal);

    // Salva no Hive usando o ID como chave
    await box.put(idFinal, produtoParaSalvar.toMap());
  }

  // 2. BUSCAR TODOS OS PRODUTOS
  static Future<List<ProdutoModel>> buscarProdutos() async {
    var box = Hive.box(_boxName);
    
    // Converte os Mapas salvos de volta para objetos ProdutoModel
    return box.values.map((item) {
      return ProdutoModel.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // 3. EXCLUIR PRODUTO
  static Future<void> excluirProduto(String id) async {
    var box = Hive.box(_boxName);
    await box.delete(id);
  }
}
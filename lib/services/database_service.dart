import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/produto_model.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionName = 'produtos';

  // Inicializa o Firebase (será chamado no main.dart)
  static Future<void> init() async {
    await Firebase.initializeApp();
  }

  // 1. SALVAR / ADICIONAR / EDITAR PRODUTO
  static Future<void> salvarProduto(ProdutoModel novoProduto) async {
    // Se o produto já tem ID, usamos ele (Edição). Se não, criamos um novo (Cadastro).
    String idFinal = novoProduto.id ?? _db.collection(_collectionName).doc().id;
    
    ProdutoModel produtoParaSalvar = novoProduto.copyWith(id: idFinal);

    // Salva no Firestore usando o ID como documento
    await _db.collection(_collectionName).doc(idFinal).set(produtoParaSalvar.toMap());
  }

  // 2. BUSCAR TODOS OS PRODUTOS
  static Future<List<ProdutoModel>> buscarProdutos() async {
    try {
      QuerySnapshot snapshot = await _db.collection(_collectionName).get();
      
      // Converte os documentos do Firestore de volta para objetos ProdutoModel
      return snapshot.docs.map((doc) {
        return ProdutoModel.fromMap(Map<String, dynamic>.from(doc.data() as Map));
      }).toList();
    } catch (e) {
      print("Erro ao buscar produtos: $e");
      return [];
    }
  }

  // 3. EXCLUIR PRODUTO
  static Future<void> excluirProduto(String id) async {
    await _db.collection(_collectionName).doc(id).delete();
  }

  // 4. (EXTRA) STREAM PARA ATUALIZAÇÃO EM TEMPO REAL
  // Se quiser usar StreamBuilder no futuro para a lista atualizar sozinha
  static Stream<List<ProdutoModel>> streamProdutos() {
    return _db.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProdutoModel.fromMap(Map<String, dynamic>.from(doc.data() as Map));
      }).toList();
    });
  }
}

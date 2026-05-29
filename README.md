# Gesto - Controle de Estoque 👙📦

O **Gesto** é um aplicativo móvel desenvolvido com Flutter projetado para simplificar o gerenciamento de inventário para pequenos empreendedores e lojas. Com uma interface moderna baseada em Material 3, o app oferece uma visão clara e rápida da saúde do seu estoque.

## 🚀 Funcionalidades

- **Dashboard Dinâmico**: Visualize indicadores em tempo real, como total de peças e alertas de estoque baixo diretamente na tela inicial.
- **Listagem Completa**: Acompanhe todos os seus produtos com detalhes de tamanho, cor e preço de venda.
- **Ações Rápidas**: Altere a quantidade de itens no estoque com apenas um toque na listagem.
- **Alertas Críticos**: Destaque visual inteligente para produtos com estoque crítico (2 ou menos unidades).
- **Gerenciamento de Produtos**: Cadastro e edição completa de itens com persistência garantida.
- **Banco de Dados Local**: Utiliza tecnologia NoSQL para alta performance e funcionamento 100% offline.

## 🛠️ Tecnologias Utilizadas

- [Flutter](https://flutter.dev/) - Framework UI.
- [Dart](https://dart.dev/) - Linguagem de programação.
- [Hive](https://pub.dev/packages/hive) - Banco de dados NoSQL leve e ultra rápido para Flutter.
- **Material 3** - Design moderno e responsivo.

## 📂 Estrutura do Projeto

- `lib/models/`: Definição da estrutura de dados dos produtos.
- `lib/screens/`: Telas da aplicação (Home, Lista e Cadastro).
- `lib/services/`: Lógica de persistência e banco de dados local.
- `lib/main.dart`: Ponto de entrada e configuração de tema do app.

## 🏁 Como Começar

### Pré-requisitos
- Flutter SDK instalado na sua máquina.
- Um emulador Android/iOS ou dispositivo físico conectado.

### Instalação

1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/gesto-controle-estoque.git
   ```

2. Entre na pasta do projeto:
   ```bash
   cd gesto-controle-estoque
   ```

3. Instale as dependências:
   ```bash
   flutter pub get
   ```

4. Execute o aplicativo:
   ```bash
   flutter run
   ```

---
Desenvolvido como um exemplo prático de gerenciamento de estado e persistência local em Flutter.

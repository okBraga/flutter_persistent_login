# 🔐 Flutter Persistent Login

Um projeto Flutter demonstrando implementação de **autenticação persistente** com Firebase, seguindo boas práticas de arquitetura, Clean Code e Design Patterns.

## ✨ Funcionalidades

- 🔑 **Autenticação com Firebase Auth**
- 💾 **Persistência de dados com SharedPreferences**
- 🗄️ **Armazenamento em Firestore**
- 🎯 **Gerenciamento de estado com Cubit (BLoC)**
- 🏗️ **Injeção de dependência com GetIt + Injectable**
- 🚪 **AuthGate para controle de rotas**
- 📱 **Boas práticas de UI/UX**

## 🛠️ Tecnologias Utilizadas

### Core
- **Flutter** - Framework de desenvolvimento
- **Dart** - Linguagem de programação

### Autenticação & Backend
- **Firebase Auth** - Autenticação de usuários
- **Cloud Firestore** - Banco de dados NoSQL
- **Firebase Core** - Configuração do Firebase

### Gerenciamento de Estado
- **flutter_bloc** - Padrão BLoC/Cubit
- **equatable** - Comparação de objetos

### Injeção de Dependência
- **get_it** - Service locator
- **injectable** - Geração automática de dependências

### Armazenamento Local
- **shared_preferences** - Persistência local
- **json_annotation** - Serialização JSON

### Desenvolvimento
- **build_runner** - Geração de código
- **json_serializable** - Serialização automática

## 🏗️ Arquitetura

O projeto segue uma arquitetura limpa com separação clara de responsabilidades:

```
lib/
├── core/
│   ├── data/
│   │   ├── datasource/
│   │   │   ├── local/          # SharedPreferences
│   │   │   └── remote/         # Firestore
│   ├── domain/
│   │   ├── entity/             # Entidades
│   │   └── repository/         # Repositórios
│   ├── di/                     # Injeção de dependência
│   ├── routes/                 # Roteamento
│   ├── styles/                 # Temas
│   └── widgets/                # Widgets compartilhados
├── features/
│   ├── login/                  # Feature de login
│   ├── sign_up/                # Feature de cadastro
│   └── home/                   # Feature principal
└── helpers/                    # Utilitários
```

## 🚀 Como Executar

1. **Clone o repositório**
   ```bash
   git clone https://github.com/okBraga/flutter_persistent_login.git
   cd flutter_persistent_login
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/) e siga as instruções.

4. **Gere os arquivos de injeção**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Execute o projeto**
   ```bash
   flutter run
   ```

## 📱 Funcionalidades Implementadas

### Autenticação
- ✅ Login com email e senha
- ✅ Cadastro de novos usuários
- ✅ Validação de formulários
- ✅ Tratamento de erros de autenticação
- ✅ Logout

### Persistência
- ✅ Verificação automática de usuário logado
- ✅ Redirecionamento inteligente (AuthGate)
- ✅ Armazenamento local seguro
- ✅ Sincronização com Firestore

### UX/UI
- ✅ Interface moderna e intuitiva
- ✅ Estados de loading
- ✅ Feedback visual de erros
- ✅ Navegação fluida entre telas

## 🎯 Pontos de Destaque

- **Clean Architecture**: Separação clara entre camadas
- **SOLID Principles**: Código bem estruturado e testável
- **Dependency Injection**: Gerenciamento automático de dependências
- **State Management**: Uso eficiente do padrão Cubit
- **Error Handling**: Tratamento robusto de erros
- **Code Generation**: Uso de ferramentas para reduzir boilerplate

## 👨‍💻 Autor

**Filipe Braga**
- LinkedIn: [okBraga](https://www.linkedin.com/in/okbraga/)
- GitHub: [okBraga](https://github.com/okBraga)

---

⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!

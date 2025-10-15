# 🤝 Guia de Contribuição - Colorindo com Deus

Obrigado por considerar contribuir com o **Colorindo com Deus**! Este documento fornece diretrizes para contribuir com o projeto.

## 🌟 Como Contribuir

Existem várias formas de contribuir com este projeto:

### 1. Reportar Bugs
- Use o sistema de Issues do GitHub
- Descreva o bug detalhadamente
- Inclua passos para reproduzir
- Adicione screenshots se possível
- Especifique versão do Flutter e do dispositivo

### 2. Sugerir Funcionalidades
- Abra uma Issue com a tag `enhancement`
- Explique o problema que a feature resolve
- Descreva a solução proposta
- Adicione mockups se tiver

### 3. Melhorar Documentação
- Corrija erros de digitação
- Melhore explicações
- Adicione exemplos
- Traduza documentação

### 4. Contribuir com Código
- Faça fork do repositório
- Crie uma branch para sua feature
- Siga as diretrizes de código
- Submeta um Pull Request

## 📋 Diretrizes de Código

### Estilo de Código

#### Dart/Flutter
```dart
// ✅ BOM
class MinhaClasse {
  final String nome;
  
  MinhaClasse({required this.nome});
  
  void meuMetodo() {
    // código aqui
  }
}

// ❌ EVITE
class minhaclasse {
  String nome;
  meuMetodo() {}
}
```

#### Convenções
- Use `camelCase` para variáveis e métodos
- Use `PascalCase` para classes
- Use `snake_case` para arquivos
- Prefira `const` quando possível
- Use trailing commas em listas

### Estrutura de Arquivos

```
lib/
├── models/          # Modelos de dados (usar classes imutáveis)
├── providers/       # Providers (ChangeNotifier)
├── screens/         # Telas completas
├── widgets/         # Widgets reutilizáveis
├── services/        # Serviços (API, Storage, etc)
├── utils/           # Utilitários e helpers
├── data/            # Dados estáticos
└── l10n/            # Internacionalização
```

### Commits

#### Formato
```
tipo(escopo): descrição curta

Descrição mais detalhada se necessário.

Fixes #123
```

#### Tipos
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Manutenção

#### Exemplos
```bash
feat(colorir): adiciona modo borracha
fix(galeria): corrige carregamento de imagens
docs(readme): atualiza instruções de instalação
style(home): ajusta espaçamento dos botões
refactor(providers): simplifica DrawingProvider
test(models): adiciona testes para Historia
chore(deps): atualiza dependências
```

### Pull Requests

#### Checklist
Antes de submeter um PR, verifique:

- [ ] Código segue as convenções do projeto
- [ ] Passou em `flutter analyze`
- [ ] Passou em `flutter test` (se houver testes)
- [ ] Documentação atualizada se necessário
- [ ] Commits bem descritos
- [ ] PR tem descrição clara
- [ ] Screenshots adicionados se mudança visual
- [ ] Testado em Android e iOS (se possível)

#### Template de PR
```markdown
## Descrição
Breve descrição da mudança.

## Tipo de Mudança
- [ ] Bug fix
- [ ] Nova feature
- [ ] Breaking change
- [ ] Documentação

## Como Testar
1. Passo 1
2. Passo 2
3. Passo 3

## Screenshots
(se aplicável)

## Checklist
- [ ] Código analisado
- [ ] Testes passando
- [ ] Documentação atualizada
```

## 🧪 Testes

### Executar Testes
```bash
# Todos os testes
flutter test

# Teste específico
flutter test test/models/historia_test.dart

# Com coverage
flutter test --coverage
```

### Escrever Testes

#### Teste de Modelo
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:colorindo_com_deus/models/historia.dart';

void main() {
  group('Historia', () {
    test('deve criar história com dados válidos', () {
      final historia = Historia(
        id: '1',
        titulo: 'Teste',
        descricao: 'Descrição',
        imagemPath: 'path',
        referenciaBiblica: 'Ref',
        desenhoId: 'desenho_1',
      );
      
      expect(historia.id, '1');
      expect(historia.titulo, 'Teste');
    });
  });
}
```

#### Teste de Widget
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('AnimatedButton deve renderizar texto', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedButton(
          text: 'Teste',
          icon: Icons.star,
          color: Colors.blue,
          onTap: () {},
        ),
      ),
    );
    
    expect(find.text('Teste'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
```

## 🎨 Design e UI

### Princípios
- **Simplicidade**: Interface limpa e fácil de usar
- **Consistência**: Mesmo estilo em todo app
- **Acessibilidade**: Elementos grandes para crianças
- **Feedback**: Visual claro de ações

### Cores
Use as cores definidas em `lib/utils/app_colors.dart`:
```dart
AppColors.primary    // Roxo principal
AppColors.secondary  // Rosa
AppColors.accent     // Amarelo
// etc...
```

### Espaçamento
Sistema de espaçamento 8px:
```dart
const SizedBox(height: 8)   // Pequeno
const SizedBox(height: 16)  // Médio
const SizedBox(height: 24)  // Grande
const SizedBox(height: 32)  // Extra grande
```

### Componentes Reutilizáveis
Antes de criar novo widget, verifique se já existe em `lib/widgets/`.

Se criar novo widget reutilizável:
- Documente parâmetros
- Torne configurável
- Use const quando possível

## 🌍 Internacionalização

### Adicionar Nova String
1. Edite `lib/l10n/app_localizations.dart`
2. Adicione em todos os idiomas:

```dart
static final Map<String, Map<String, String>> _localizedValues = {
  'pt_BR': {
    'nova_chave': 'Novo Texto',
  },
  'en_US': {
    'nova_chave': 'New Text',
  },
  'es_ES': {
    'nova_chave': 'Nuevo Texto',
  },
};
```

3. Adicione getter:
```dart
String get novaChave => translate('nova_chave');
```

### Usar String Localizada
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.novaChave)
```

## 📱 Testar em Dispositivos

### Android
```bash
# Listar dispositivos
adb devices

# Instalar e executar
flutter run -d <device-id>

# Logs
flutter logs
```

### iOS
```bash
# Listar simuladores
xcrun simctl list devices

# Executar
flutter run -d <device-id>
```

## 🐛 Debug

### Ferramentas Úteis

#### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

#### Hot Reload
- **r**: Hot reload
- **R**: Hot restart
- **p**: Grid de layout
- **q**: Quit

#### Logs
```dart
// Use debugPrint ao invés de print
debugPrint('Mensagem de debug');

// Para objetos complexos
debugPrint('Objeto: ${objeto.toString()}');
```

## 📊 Performance

### Boas Práticas
- Use `const` widgets sempre que possível
- Evite rebuilds desnecessários
- Use `ListView.builder` para listas longas
- Otimize imagens (tamanho e formato)
- Profile antes de otimizar

### Profiling
```bash
flutter run --profile
# Abra DevTools e vá para Performance
```

## 🔒 Segurança

### Diretrizes
- Nunca commite chaves de API
- Use `.env` para secrets
- Valide inputs do usuário
- Trate erros apropriadamente
- Use HTTPS para APIs

## 📦 Dependências

### Adicionar Nova Dependência

1. Justifique a necessidade
2. Verifique popularidade no pub.dev
3. Adicione ao `pubspec.yaml`
4. Execute `flutter pub get`
5. Documente uso se necessário

### Atualizar Dependências
```bash
# Ver outdated
flutter pub outdated

# Atualizar
flutter pub upgrade

# Testar após atualizar
flutter test
flutter run
```

## 📝 Documentação de Código

### Documente Classes e Métodos
```dart
/// Widget que exibe um botão animado.
///
/// Usa scale animation ao ser tocado.
/// Requer [text], [icon], [color] e [onTap].
class AnimatedButton extends StatefulWidget {
  /// Texto exibido no botão
  final String text;
  
  /// Ícone exibido à esquerda do texto
  final IconData icon;
  
  /// Cor de fundo do botão
  final Color color;
  
  /// Callback executado ao tocar
  final VoidCallback onTap;
  
  const AnimatedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  
  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}
```

## 🎯 Áreas que Precisam de Ajuda

### Alta Prioridade
- [ ] Parser de SVG para desenhos reais
- [ ] Sistema de compartilhamento completo
- [ ] Testes unitários e de widget
- [ ] Assets de mídia (desenhos, sons, etc)

### Média Prioridade
- [ ] Sistema de conquistas/medalhas
- [ ] Animações mais elaboradas
- [ ] Modo tutorial
- [ ] Analytics

### Baixa Prioridade
- [ ] Mais idiomas
- [ ] Temas personalizados
- [ ] Easter eggs
- [ ] Modo multiplayer

## 💬 Comunicação

### Onde Conversar
- **Issues**: Para bugs e features
- **Discussions**: Para perguntas gerais
- **Pull Requests**: Para discussão de código

### Seja Respeitoso
- Trate todos com respeito
- Seja construtivo nas críticas
- Agradeça contribuições
- Seja paciente com iniciantes

## 🏆 Reconhecimento

Todos os contribuidores serão:
- Listados no README
- Mencionados nos changelogs
- Creditados na tela "Sobre" do app

## 📜 Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a MIT License.

---

**Obrigado por contribuir!** ❤️

Que Deus abençoe seu trabalho neste projeto! 🙏


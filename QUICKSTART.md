# ⚡ Guia Rápido - Colorindo com Deus

**Para começar rapidamente em 5 minutos!**

## 🚀 Início Rápido

### 1. Instalar Dependências
```bash
flutter pub get
```

### 2. Executar o App
```bash
flutter run
```

Pronto! O app já funciona com dados de exemplo. 🎉

## 📦 O Mínimo Necessário para Testar

O app funciona **sem nenhum asset externo**, mas para melhorar a experiência:

### Apenas Adicione as Fontes (Opcional)
1. Baixe Comic Neue: https://fonts.google.com/specimen/Comic+Neue
2. Extraia e copie para `assets/fonts/`:
   - `ComicNeue-Regular.ttf`
   - `ComicNeue-Bold.ttf`
3. Reinicie o app

**Tudo mais é opcional para testes!**

## 🎯 Navegação Básica

### Telas Principais
1. **Home** → Menu principal
2. **Começar a Colorir** → Escolhe desenho
3. **Colorir** → Pinta o desenho
4. **Histórias** → Lê histórias bíblicas
5. **Galeria** → Vê desenhos salvos
6. **Configurações** → Ajusta idioma, tema, etc
7. **Sobre** → Informações do app

## 🎨 Testar Funcionalidade de Colorir

1. Abra o app
2. Toque em "Começar a Colorir"
3. Escolha qualquer desenho
4. Selecione uma cor na paleta inferior
5. Toque nas áreas do desenho
6. Use os botões:
   - **↶**: Desfazer
   - **↷**: Refazer
   - **💾**: Salvar
   - **✓**: Finalizar

## 🌍 Testar Idiomas

1. Vá em Configurações
2. Toque em Idioma
3. Escolha: Português, English ou Español
4. Interface muda instantaneamente

## 🌙 Testar Modo Escuro

1. Vá em Configurações
2. Ative "Modo Escuro"
3. App muda para tema escuro

## 💾 Testar Persistência

1. Colorir um desenho
2. Toque em Salvar
3. Feche o app (force stop)
4. Abra novamente
5. Vá no mesmo desenho
6. Cores estarão salvas!

## 🖼️ Testar Galeria

1. Colorir um desenho
2. Toque em "Finalizar"
3. Veja a modal de parabéns com versículo
4. Vá em Galeria
5. Desenho aparece em "Finalizados"
6. Toque para ver opções

## 📖 Testar Histórias

1. Vá em "Histórias"
2. Leia qualquer história
3. Toque em "Colorir essa História"
4. Vai direto para o desenho relacionado

## 🐛 Troubleshooting Rápido

### App não inicia
```bash
flutter clean
flutter pub get
flutter run
```

### Erro de dependências
```bash
flutter doctor
# Siga as instruções para corrigir
```

### Fontes não carregam
- Normal se não adicionou as fontes
- App usa fonte padrão do sistema
- Não afeta funcionalidade

### Desenhos aparecem como retângulos
- Normal! São placeholders
- Funcionalidade de colorir funciona
- Para desenhos reais, veja NEXT_STEPS.md

## 📱 Testar em Dispositivo Real

### Android
```bash
# Conecte dispositivo USB com debug habilitado
adb devices
flutter run
```

### iOS
```bash
# Conecte iPhone/iPad
flutter devices
flutter run -d <device-id>
```

## 🔥 Hot Reload

Com app rodando:
- Altere código
- Salve arquivo
- Pressione `r` no terminal
- Mudanças aparecem instantaneamente!

## 📊 Estrutura em 30 Segundos

```
lib/
├── main.dart          ← Inicia aqui
├── screens/           ← Telas do app
├── widgets/           ← Componentes UI
├── providers/         ← Lógica de estado
├── models/            ← Dados
├── data/              ← Histórias e desenhos
└── utils/             ← Cores e constantes
```

## 🎯 Próximos Passos

Depois de testar, veja:
1. **NEXT_STEPS.md** - O que fazer a seguir
2. **FEATURES.md** - Todas as funcionalidades
3. **SETUP.md** - Setup completo
4. **CONTRIBUTING.md** - Como contribuir

## 💡 Dicas Rápidas

### Desenvolvimento
- Use **Hot Reload** (`r`) para ver mudanças
- Use **DevTools** para debug
- `flutter analyze` para checar código

### Customização Rápida
- Cores: `lib/utils/app_colors.dart`
- Textos: `lib/l10n/app_localizations.dart`
- Histórias: `lib/data/historias_data.dart`

### Performance
```bash
# Ver tamanho do app
flutter build apk --analyze-size

# Profile de performance
flutter run --profile
```

## 🎨 Exemplos de Modificação Rápida

### Mudar Cor Primária
```dart
// lib/utils/app_colors.dart
static const Color primary = Color(0xFF6C63FF); // Roxo
// Mude para:
static const Color primary = Color(0xFFFF5722); // Laranja
```

### Adicionar Nova Cor na Paleta
```dart
// lib/utils/app_colors.dart
static const List<Color> paintColors = [
  // ... cores existentes
  Color(0xFF00BCD4), // Adicione aqui
];
```

### Adicionar Nova História
```dart
// lib/data/historias_data.dart
Historia(
  id: '11',
  titulo: 'Minha História',
  descricao: 'Descrição...',
  imagemPath: 'assets/images/stories/minha.png',
  referenciaBiblica: 'Livro 1:1',
  desenhoId: 'desenho_11',
),
```

## 🏁 Checklist de Teste Rápido

Teste estas funcionalidades:
- [ ] App inicia
- [ ] Navegação entre telas
- [ ] Colorir desenho
- [ ] Selecionar cores
- [ ] Undo/Redo
- [ ] Salvar progresso
- [ ] Finalizar desenho
- [ ] Ver galeria
- [ ] Ler histórias
- [ ] Mudar idioma
- [ ] Mudar tema
- [ ] Modo escuro funciona
- [ ] App fecha e abre sem perder dados

## 📞 Precisa de Ajuda?

1. Veja **SETUP.md** para instalação completa
2. Veja **FEATURES.md** para entender funcionalidades
3. Abra uma Issue no GitHub
4. Leia documentação do Flutter: https://flutter.dev

---

**Divirta-se desenvolvendo!** 🎉

Tempo total de setup: **~5 minutos** ⏱️


# 🚀 Guia de Configuração - Colorindo com Deus

Este guia irá ajudá-lo a configurar e executar o aplicativo **Colorindo com Deus** no seu ambiente de desenvolvimento.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter os seguintes softwares instalados:

### 1. Flutter SDK

- **Versão requerida**: Flutter 3.0.0 ou superior
- **Download**: https://flutter.dev/docs/get-started/install
- **Verificação**: Execute `flutter --version` no terminal

### 2. Editor de Código

Recomendamos um dos seguintes:

- **Visual Studio Code** com extensões:
  - Flutter
  - Dart
  - Flutter Widget Snippets

- **Android Studio** com plugins:
  - Flutter
  - Dart

### 3. Ambiente de Desenvolvimento

#### Para Android:
- Android Studio
- Android SDK (API 21+)
- Emulador Android ou dispositivo físico

#### Para iOS (apenas macOS):
- Xcode 12+
- CocoaPods
- Simulador iOS ou dispositivo físico

## 🔧 Instalação

### Passo 1: Clone o Repositório

```bash
git clone [url-do-repositorio]
cd colorindo_com_deus
```

### Passo 2: Instale as Dependências

```bash
flutter pub get
```

### Passo 3: Adicione os Assets Necessários

#### Fontes

1. Baixe a fonte **Comic Neue** de: https://fonts.google.com/specimen/Comic+Neue
2. Extraia os arquivos:
   - `ComicNeue-Regular.ttf`
   - `ComicNeue-Bold.ttf`
3. Coloque-os na pasta: `assets/fonts/`

#### Ícones do App

1. Crie ou baixe um ícone para o aplicativo (1024x1024 px)
2. Salve como `icon.png` em: `assets/icon/`
3. Para Android adaptive icon, crie também: `icon_foreground.png`

#### Imagens de Desenhos (Opcional para testes)

As pastas já estão criadas em:
- `assets/images/stories/` - Imagens das histórias
- `assets/images/drawings/` - Desenhos para colorir

**Nota**: O app funcionará mesmo sem as imagens, mostrando placeholders.

### Passo 4: Gere os Ícones do App (Opcional)

```bash
flutter pub run flutter_launcher_icons
```

### Passo 5: Verifique a Instalação

```bash
flutter doctor
```

Este comando verificará se tudo está configurado corretamente.

## 🎯 Executando o Aplicativo

### Modo Debug

```bash
# Listar dispositivos disponíveis
flutter devices

# Executar no dispositivo padrão
flutter run

# Executar em dispositivo específico
flutter run -d <device-id>
```

### Modo Release

```bash
flutter run --release
```

### Hot Reload

Durante o desenvolvimento, você pode usar:
- **Hot Reload**: Pressione `r` no terminal (recarrega o código)
- **Hot Restart**: Pressione `R` no terminal (reinicia o app)

## 📱 Build para Produção

### Android (APK)

```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### Android (App Bundle)

```bash
flutter build appbundle --release
```

### iOS (requer macOS)

```bash
flutter build ios --release
```

## 🐛 Solução de Problemas

### Problema: Dependências não encontradas

**Solução**:
```bash
flutter clean
flutter pub get
```

### Problema: Erro de versão do Gradle (Android)

**Solução**: Abra `android/gradle/wrapper/gradle-wrapper.properties` e ajuste a versão.

### Problema: Fontes não aparecem

**Solução**:
1. Verifique se as fontes estão na pasta correta
2. Execute `flutter clean && flutter pub get`
3. Reinicie o app

### Problema: Assets não encontrados

**Solução**:
1. Verifique o `pubspec.yaml` - seção `flutter: assets:`
2. Execute `flutter clean && flutter pub get`

## 📂 Estrutura de Pastas Importante

```
colorindo_com_deus/
├── lib/
│   ├── main.dart              # Entry point
│   ├── models/                # Modelos de dados
│   ├── providers/             # Gerenciamento de estado
│   ├── screens/               # Telas do app
│   ├── widgets/               # Componentes reutilizáveis
│   ├── data/                  # Dados estáticos
│   ├── l10n/                  # Internacionalização
│   ├── services/              # Serviços (áudio, etc)
│   └── utils/                 # Utilitários e constantes
├── assets/
│   ├── images/                # Imagens gerais
│   ├── fonts/                 # Fontes personalizadas
│   ├── sounds/                # Efeitos sonoros
│   ├── audio/                 # Narrações
│   └── icon/                  # Ícones do app
├── android/                   # Configuração Android
├── ios/                       # Configuração iOS
└── pubspec.yaml              # Dependências
```

## 🔑 Configurações Importantes

### Orientação de Tela

O app está configurado para funcionar apenas em modo **retrato (portrait)**.
Configuração em: `lib/main.dart`

### Tema

- Tema claro e escuro disponíveis
- Cores configuráveis em: `lib/utils/app_colors.dart`

### Idiomas Suportados

- Português (pt_BR) - Padrão
- English (en_US)
- Español (es_ES)

## 📝 Scripts Úteis

### Análise de Código

```bash
flutter analyze
```

### Testes (quando implementados)

```bash
flutter test
```

### Verificar Performance

```bash
flutter run --profile
```

## 🎨 Personalizações

### Adicionar Nova História

1. Edite: `lib/data/historias_data.dart`
2. Adicione nova entrada em `obterHistorias()`
3. Crie desenho correspondente em `lib/data/desenhos_data.dart`

### Adicionar Nova Cor à Paleta

1. Edite: `lib/utils/app_colors.dart`
2. Adicione cor em `paintColors`

### Mudar Tema

1. Edite: `lib/utils/app_colors.dart`
2. Modifique as cores primárias

## 📧 Suporte

Se encontrar problemas:

1. Verifique a documentação do Flutter: https://flutter.dev/docs
2. Consulte os issues do projeto
3. Entre em contato: contato@colorindocomdeus.com

## 🎉 Pronto!

Agora você está pronto para desenvolver e testar o **Colorindo com Deus**!

```bash
flutter run
```

Bom desenvolvimento! 🚀


# 🚀 Guia de Instalação do Flutter - Múltiplas Opções

## 📋 Índice
1. [Opção 1: Instalação Manual (Recomendado)](#opção-1-instalação-manual)
2. [Opção 2: Via Winget](#opção-2-via-winget)
3. [Opção 3: Via Chocolatey](#opção-3-via-chocolatey)
4. [Opção 4: Via Git](#opção-4-via-git)
5. [Verificação da Instalação](#verificação)

---

## Opção 1: Instalação Manual (Recomendado) ⭐

### Passo 1: Baixar o Flutter

**Opção A - Navegador:**
1. Abra seu navegador
2. Acesse: https://docs.flutter.dev/get-started/install/windows
3. Clique no botão azul "Download Flutter SDK"
4. Baixe o arquivo `flutter_windows_3.24.3-stable.zip` (aproximadamente 1.5 GB)

**Opção B - Download Direto:**
- Link direto: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip

### Passo 2: Extrair os Arquivos

1. Vá até a pasta **Downloads**
2. Localize o arquivo `flutter_windows_3.24.3-stable.zip`
3. **Botão direito** no arquivo → **Extrair Tudo...**
4. Escolha extrair para: `C:\`
5. Clique em **Extrair**
6. Aguarde a extração (pode levar alguns minutos)
7. Você terá agora a pasta: `C:\flutter`

### Passo 3: Adicionar ao PATH

1. Pressione `Windows + R`
2. Digite: `sysdm.cpl` e pressione Enter
3. Vá para a aba **Avançado**
4. Clique em **Variáveis de Ambiente**
5. Na seção **Variáveis do usuário**, localize **Path**
6. Selecione **Path** e clique em **Editar**
7. Clique em **Novo**
8. Digite: `C:\flutter\bin`
9. Clique em **OK** em todas as janelas

### Passo 4: Reiniciar Terminal

1. **Feche completamente** o PowerShell/Terminal
2. **Abra novamente** como Administrador
3. Execute: `flutter --version`

Se aparecer a versão do Flutter, está funcionando! ✅

---

## Opção 2: Via Winget 🪟

O Winget vem pré-instalado no Windows 10/11 moderno.

### Comandos:

```powershell
# Abra PowerShell como Administrador

# Instalar Flutter
winget install -e --id=9NZCC27PR6N5

# OU

winget install Flutter.Flutter
```

### Verificar:
```powershell
flutter --version
```

---

## Opção 3: Via Chocolatey 🍫

### Passo 1: Instalar Chocolatey

Abra PowerShell como **Administrador** e execute:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Passo 2: Instalar Flutter

```powershell
choco install flutter -y
```

### Passo 3: Verificar

```powershell
flutter --version
```

---

## Opção 4: Via Git 🐙

Se você tem Git instalado:

```powershell
# Abra PowerShell

# Clone o repositório Flutter
git clone https://github.com/flutter/flutter.git -b stable C:\flutter

# Adicione ao PATH temporariamente
$env:Path += ";C:\flutter\bin"

# Verifique
flutter --version
```

**Importante:** Depois adicione `C:\flutter\bin` ao PATH permanentemente (ver Opção 1, Passo 3).

---

## ✅ Verificação da Instalação {#verificação}

Após qualquer método de instalação:

### 1. Verificar Versão
```powershell
flutter --version
```

Deve mostrar algo como:
```
Flutter 3.24.3 • channel stable
```

### 2. Executar Flutter Doctor
```powershell
flutter doctor
```

Isso verifica todas as dependências.

### 3. Aceitar Licenças Android (se tiver Android Studio)
```powershell
flutter doctor --android-licenses
```

Pressione `y` para aceitar todas.

### 4. Verificar Dispositivos
```powershell
flutter devices
```

---

## 🔧 Instalação do Projeto Colorindo com Deus

Após instalar o Flutter com sucesso:

```powershell
# 1. Navegue até o projeto
cd "C:\Users\Caio\Desktop\Projetos\Projeto App - Colorindo com Deus"

# 2. Instale as dependências
flutter pub get

# 3. Verifique se está tudo OK
flutter doctor

# 4. Execute o app
flutter run
```

---

## 🆘 Problemas Comuns

### Erro: "flutter não é reconhecido"

**Solução:**
1. Feche e reabra o terminal
2. Verifique se `C:\flutter\bin` está no PATH
3. Execute como Administrador

### Erro de Rede ao Baixar

**Solução:**
1. Desative temporariamente antivírus/firewall
2. Tente em outra rede (celular como hotspot)
3. Use VPN se necessário
4. Baixe manualmente pelo navegador

### Flutter Doctor mostra avisos

**Solução:**
- Android Studio não instalado: Normal se você só quer testar no navegador/desktop
- Chrome não encontrado: Instale Google Chrome
- Visual Studio não instalado: Necessário apenas para Windows Desktop apps

---

## 📱 Executar no Navegador (Não precisa Android)

Se não quiser instalar Android Studio agora:

```powershell
# Execute no Chrome
flutter run -d chrome
```

---

## 🎯 Resumo Rápido

**Melhor para você:**
1. **Baixe manualmente** do site oficial
2. Extraia para `C:\flutter`
3. Adicione `C:\flutter\bin` ao PATH
4. Reinicie o terminal
5. Execute `flutter doctor`
6. Vá para o projeto e execute `flutter pub get`

---

## 📞 Precisa de Ajuda?

Se tiver qualquer problema:
1. Copie a mensagem de erro exata
2. Execute `flutter doctor -v` para detalhes
3. Verifique se tem espaço em disco (mínimo 5GB)
4. Verifique se tem permissões de administrador

---

**Criado para o projeto Colorindo com Deus 🎨📖**




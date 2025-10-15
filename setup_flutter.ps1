# ====================================
# Instalador do Flutter SDK - Simples
# ====================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  INSTALADOR DO FLUTTER SDK" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Configurações
$flutterDir = "C:\flutter"
$flutterZip = "$env:TEMP\flutter_sdk.zip"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip"

# Passo 1: Verificar se Flutter já está instalado
Write-Host "[1/5] Verificando instalação existente..." -ForegroundColor Yellow
if (Test-Path "$flutterDir\bin\flutter.bat") {
    Write-Host "      Flutter já está instalado em $flutterDir" -ForegroundColor Green
    $resposta = Read-Host "      Deseja reinstalar? (s/n)"
    if ($resposta -ne "s") {
        Write-Host "`nInstalação cancelada." -ForegroundColor Yellow
        exit 0
    }
    Write-Host "      Removendo instalação antiga..." -ForegroundColor Yellow
    Remove-Item -Path $flutterDir -Recurse -Force -ErrorAction SilentlyContinue
}

# Passo 2: Criar diretório
Write-Host "`n[2/5] Criando diretório de instalação..." -ForegroundColor Yellow
if (!(Test-Path $flutterDir)) {
    New-Item -ItemType Directory -Path $flutterDir -Force | Out-Null
    Write-Host "      Diretório criado: $flutterDir" -ForegroundColor Green
}

# Passo 3: Baixar Flutter
Write-Host "`n[3/5] Baixando Flutter SDK..." -ForegroundColor Yellow
Write-Host "      URL: $flutterUrl" -ForegroundColor Gray
Write-Host "      Aguarde, isso pode levar alguns minutos..." -ForegroundColor Gray

try {
    # Desabilitar barra de progresso para acelerar download
    $ProgressPreference = 'SilentlyContinue'
    
    # Baixar arquivo
    Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -TimeoutSec 300
    
    $fileSize = (Get-Item $flutterZip).Length / 1MB
    Write-Host "      Download concluído! (${fileSize} MB)" -ForegroundColor Green
}
catch {
    Write-Host "`n      ERRO ao baixar Flutter:" -ForegroundColor Red
    Write-Host "      $_" -ForegroundColor Red
    Write-Host "`n      Possíveis soluções:" -ForegroundColor Yellow
    Write-Host "      - Verifique sua conexão com a internet" -ForegroundColor White
    Write-Host "      - Desative temporariamente o antivírus/firewall" -ForegroundColor White
    Write-Host "      - Baixe manualmente em: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor White
    exit 1
}

# Passo 4: Extrair Flutter
Write-Host "`n[4/5] Extraindo arquivos..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force
    Write-Host "      Extração concluída!" -ForegroundColor Green
}
catch {
    Write-Host "`n      ERRO ao extrair:" -ForegroundColor Red
    Write-Host "      $_" -ForegroundColor Red
    exit 1
}

# Limpar arquivo temporário
Remove-Item $flutterZip -Force -ErrorAction SilentlyContinue

# Passo 5: Configurar PATH
Write-Host "`n[5/5] Configurando variável de ambiente PATH..." -ForegroundColor Yellow

$flutterBin = "$flutterDir\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($userPath -notlike "*$flutterBin*") {
    # Adicionar ao PATH do usuário
    $newPath = "$userPath;$flutterBin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "      Flutter adicionado ao PATH do usuário!" -ForegroundColor Green
} else {
    Write-Host "      Flutter já está no PATH!" -ForegroundColor Green
}

# Atualizar PATH da sessão atual
$env:Path = "$env:Path;$flutterBin"

# Finalização
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  INSTALAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Testando instalação..." -ForegroundColor Yellow
Write-Host ""

# Executar flutter doctor
& "$flutterBin\flutter.bat" --version

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  PRÓXIMOS PASSOS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "1. Feche e reabra o PowerShell/Terminal" -ForegroundColor White
Write-Host "2. Execute: flutter doctor" -ForegroundColor Yellow
Write-Host "3. Execute: flutter doctor --android-licenses" -ForegroundColor Yellow
Write-Host "4. Navegue até o projeto: cd 'C:\Users\Caio\Desktop\Projetos\Projeto App - Colorindo com Deus'" -ForegroundColor Yellow
Write-Host "5. Instale dependências: flutter pub get" -ForegroundColor Yellow
Write-Host "6. Execute o app: flutter run" -ForegroundColor Yellow

Write-Host "`n========================================`n" -ForegroundColor Cyan
Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")







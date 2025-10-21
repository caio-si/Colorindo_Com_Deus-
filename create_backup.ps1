# 🎨 Script de Backup - Colorindo com Deus App
# 📅 Criado em: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

param(
    [string]$BackupName = "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
)

Write-Host "🎨 Criando backup do projeto Colorindo com Deus..." -ForegroundColor Cyan

# Criar diretório de backup
$BackupDir = "backups\$BackupName"
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

Write-Host "📁 Diretório de backup criado: $BackupDir" -ForegroundColor Green

# Copiar arquivos principais
$FilesToBackup = @(
    "lib\",
    "assets\",
    "pubspec.yaml",
    "analysis_options.yaml",
    "README.md"
)

foreach ($File in $FilesToBackup) {
    if (Test-Path $File) {
        Copy-Item -Path $File -Destination $BackupDir -Recurse -Force
        Write-Host "✅ Copiado: $File" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Não encontrado: $File" -ForegroundColor Yellow
    }
}

# Criar arquivo de informações do backup
$BackupInfo = @"
# 🎨 BACKUP - Colorindo com Deus App
## 📅 Data: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
## 🏷️ Nome: $BackupName

## 📁 Arquivos incluídos:
- lib/ (código fonte)
- assets/ (imagens, ícones, sons)
- pubspec.yaml (dependências)
- analysis_options.yaml (configurações)
- README.md (documentação)

## 🚀 Para restaurar:
1. Copie os arquivos de volta para o projeto
2. Execute: flutter clean
3. Execute: flutter pub get
4. Execute: flutter run

## 🎯 Status do projeto no momento do backup:
- ✅ Sistema de desenho livre funcionando
- ✅ Ferramentas com ícones PNG personalizados
- ✅ Paleta de cores clay com 50+ cores
- ✅ Sistema de galeria funcionando
- ✅ Histórias bíblicas funcionando
- ✅ Interface com logo personalizado
- ✅ Tela de loading com animações
- ✅ Sem erros de overflow

## 📝 Notas:
- Todas as funcionalidades principais estão operacionais
- Layout otimizado sem problemas de overflow
- Assets configurados corretamente
- Sistema de estado funcionando perfeitamente
"@

$BackupInfo | Out-File -FilePath "$BackupDir\BACKUP_INFO.md" -Encoding UTF8

Write-Host "📄 Arquivo de informações criado: BACKUP_INFO.md" -ForegroundColor Green

# Criar arquivo ZIP do backup
$ZipPath = "backups\${BackupName}.zip"
Compress-Archive -Path $BackupDir -DestinationPath $ZipPath -Force

Write-Host "📦 Arquivo ZIP criado: $ZipPath" -ForegroundColor Green

# Limpar diretório temporário
Remove-Item -Path $BackupDir -Recurse -Force

Write-Host "🎉 Backup concluído com sucesso!" -ForegroundColor Cyan
Write-Host "📁 Localização: $ZipPath" -ForegroundColor White
Write-Host "💾 Tamanho: $([math]::Round((Get-Item $ZipPath).Length / 1MB, 2)) MB" -ForegroundColor White

# Mostrar informações do sistema
Write-Host "`n🖥️ Informações do sistema:" -ForegroundColor Cyan
Write-Host "OS: $([System.Environment]::OSVersion.VersionString)" -ForegroundColor White
Write-Host "PowerShell: $($PSVersionTable.PSVersion)" -ForegroundColor White
Write-Host "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White

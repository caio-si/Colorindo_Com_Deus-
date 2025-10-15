@echo off
chcp 65001 >nul
echo.
echo ========================================
echo   BAIXANDO FLUTTER SDK
echo ========================================
echo.
echo Este processo irá:
echo 1. Baixar o Flutter SDK (~900MB)
echo 2. Você precisará extrair manualmente
echo 3. Adicionar ao PATH
echo.
echo Aguarde...
echo.

set DOWNLOAD_DIR=%USERPROFILE%\Downloads
set FLUTTER_ZIP=%DOWNLOAD_DIR%\flutter_windows.zip
set FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip

echo Baixando Flutter para: %FLUTTER_ZIP%
echo.
echo AGUARDE - Isso pode levar alguns minutos...
echo.

powershell -Command "& {$ProgressPreference = 'SilentlyContinue'; Write-Host 'Iniciando download...' -ForegroundColor Yellow; Invoke-WebRequest -Uri '%FLUTTER_URL%' -OutFile '%FLUTTER_ZIP%' -TimeoutSec 600; Write-Host 'Download concluído!' -ForegroundColor Green}"

if exist "%FLUTTER_ZIP%" (
    echo.
    echo ========================================
    echo   DOWNLOAD CONCLUÍDO!
    echo ========================================
    echo.
    echo O arquivo foi salvo em:
    echo %FLUTTER_ZIP%
    echo.
    echo PRÓXIMOS PASSOS:
    echo.
    echo 1. Vá até a pasta Downloads
    echo 2. Extraia o arquivo flutter_windows.zip para C:\
    echo 3. Você terá a pasta C:\flutter
    echo.
    echo 4. Adicione ao PATH:
    echo    - Pressione Windows + R
    echo    - Digite: sysdm.cpl
    echo    - Aba Avançado ^> Variáveis de Ambiente
    echo    - Edite Path (usuário)
    echo    - Adicione: C:\flutter\bin
    echo.
    echo 5. Reinicie o terminal e execute:
    echo    flutter --version
    echo.
    start "" "%DOWNLOAD_DIR%"
) else (
    echo.
    echo ========================================
    echo   ERRO NO DOWNLOAD
    echo ========================================
    echo.
    echo O download falhou. Tente:
    echo 1. Baixar manualmente em https://flutter.dev
    echo 2. Verificar sua conexão com internet
    echo 3. Desativar antivírus temporariamente
    echo.
)

pause



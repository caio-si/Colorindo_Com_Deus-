Use o@echo off
echo ========================================
echo   Colorindo com Deus - Executor
echo ========================================
echo.

echo 1. Navegando para o diretorio do projeto...
cd /d "%~dp0"
if %errorlevel% neq 0 (
    echo ERRO: Nao foi possivel navegar para o diretorio!
    pause
    exit /b 1
)

echo 2. Verificando Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ERRO: Flutter nao foi encontrado!
    echo Verifique se o Flutter esta instalado corretamente.
    pause
    exit /b 1
)

echo.
echo 3. Verificando configuracao (flutter doctor)...
flutter doctor
echo.
echo Pressione qualquer tecla para continuar...
pause

echo.
echo 4. Instalando dependencias...
flutter pub get
if %errorlevel% neq 0 (
    echo ERRO: Falha ao instalar dependencias!
    pause
    exit /b 1
)

echo.
echo 5. Verificando dispositivos disponiveis...
flutter devices

echo.
echo 6. Executando o aplicativo...
echo ========================================
echo   APLICATIVO SENDO INICIADO...
echo ========================================
flutter run

echo.
echo Pressione qualquer tecla para fechar...
pause

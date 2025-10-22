@echo off
echo Configurando SSL para Android Studio...

REM Configurar variáveis de ambiente para SSL
set GRADLE_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStorePassword= -Dsun.security.ssl.allowUnsafeRenegotiation=true -Dhttps.protocols=TLSv1.2,TLSv1.3 -Dcom.sun.net.ssl.checkRevocation=false -Dtrust_all_cert=true

REM Configurar JAVA_OPTS
set JAVA_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStorePassword= -Dsun.security.ssl.allowUnsafeRenegotiation=true -Dhttps.protocols=TLSv1.2,TLSv1.3 -Dcom.sun.net.ssl.checkRevocation=false -Dtrust_all_cert=true

echo Variáveis configuradas:
echo GRADLE_OPTS=%GRADLE_OPTS%
echo JAVA_OPTS=%JAVA_OPTS%

echo.
echo Agora inicie o Android Studio e tente compilar novamente.
echo.
pause

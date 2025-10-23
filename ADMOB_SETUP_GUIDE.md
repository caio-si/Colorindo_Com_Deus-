# 🎯 Guia Completo - Configuração AdMob

## 📱 **Passo 1: Configurar AdMob**

### **1.1 Acesse o AdMob:**
- Vá para: https://admob.google.com/
- Faça login com sua conta Google

### **1.2 Criar App:**
1. Clique em **"Apps"** no menu lateral
2. Clique em **"+ Adicionar app"**
3. Selecione **"Adicionar app manualmente"**
4. Preencha:
   - **Nome do app**: "Colorindo com Deus"
   - **Plataforma**: Android
   - **Categoria**: Educação

### **1.3 Obter IDs:**
Após criar o app, você receberá:
- **App ID**: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`
- **Banner Ad Unit ID**: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`
- **Interstitial Ad Unit ID**: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`
- **Rewarded Ad Unit ID**: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`

---

## 🔧 **Passo 2: Configurar Android**

### **2.1 Adicionar ao android/app/src/main/AndroidManifest.xml:**
```xml
<manifest>
    <application>
        <!-- AdMob App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
    </application>
</manifest>
```

### **2.2 Adicionar permissões (se necessário):**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

## 📝 **Passo 3: Atualizar Código**

### **3.1 Substituir IDs no AdService:**
```dart
// Em lib/services/ad_service.dart
static const String _appId = 'SEU_APP_ID_AQUI';
static const String _bannerAdId = 'SEU_BANNER_ID_AQUI';
static const String _interstitialAdId = 'SEU_INTERSTITIAL_ID_AQUI';
static const String _rewardedAdId = 'SEU_REWARDED_ID_AQUI';
```

### **3.2 Inicializar no main.dart:**
```dart
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  runApp(MyApp());
}
```

---

## 🧪 **Passo 4: Testar**

### **4.1 IDs de Teste (para desenvolvimento):**
```dart
// Use estes IDs durante desenvolvimento
static const String _appId = 'ca-app-pub-3940256099942544~3347511713';
static const String _bannerAdId = 'ca-app-pub-3940256099942544/6300978111';
static const String _interstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
static const String _rewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
```

### **4.2 Testar em Dispositivo Real:**
- Anúncios não funcionam no emulador
- Use dispositivo físico para testes

---

## 🚀 **Passo 5: Implementar no App**

### **5.1 Banner na Tela Inicial:**
```dart
// Em lib/screens/home_screen.dart
import '../widgets/banner_ad_widget.dart';

// Adicione no final da tela:
BannerAdWidget()
```

### **5.2 Interstitial entre Histórias:**
```dart
// Em lib/screens/stories_screen.dart
import '../widgets/interstitial_ad_service.dart';

// Após navegar para história:
AdService.incrementInterstitialCounter();
await InterstitialAdService.checkAndShowInterstitial();
```

### **5.3 Banner na Tela de Colorir:**
```dart
// Em lib/screens/coloring_screen.dart
import '../widgets/banner_ad_widget.dart';

// Adicione no final da tela:
BannerAdWidget()
```

### **5.4 Desbloqueio por Vídeo:**
```dart
// Em lib/screens/stories_screen.dart
import '../widgets/unlock_story_widget.dart';

// Para histórias bloqueadas:
if (AdService.isStoryLocked(historia.id)) {
  return UnlockStoryWidget(
    storyId: historia.id,
    storyTitle: historia.titulo,
    onUnlocked: () {
      // Atualizar UI
      setState(() {});
    },
  );
}
```

---

## 💰 **Passo 6: Configurar Monetização**

### **6.1 Estratégia de Anúncios:**
- **Banner**: Sempre visível (não invasivo)
- **Interstitial**: A cada 2-3 histórias
- **Rewarded**: Para desbloquear conteúdo

### **6.2 Histórias Bloqueadas:**
- Últimas 3 histórias (9, 10, 11)
- Desbloqueio por vídeo ou premium

### **6.3 Premium (R$ 12,99):**
- Sem anúncios
- Todas as histórias liberadas
- Cores especiais
- Ferramentas avançadas

---

## ⚠️ **Importante:**

### **🔒 Privacidade:**
- Adicione política de privacidade
- Configure GDPR se necessário

### **📱 Testes:**
- Use IDs de teste durante desenvolvimento
- Teste em dispositivos reais
- Verifique se anúncios não travam o app

### **🚀 Produção:**
- Substitua IDs de teste pelos reais
- Configure anúncios para produção
- Monitore performance

---

## 📞 **Suporte:**

Se tiver problemas:
1. Verifique se IDs estão corretos
2. Confirme se app está no AdMob
3. Teste em dispositivo real
4. Verifique logs do console

**Boa sorte com a monetização! 🎯💰**

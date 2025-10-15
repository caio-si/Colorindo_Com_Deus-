# Como Criar Imagens de Máscara para Colorir

## 📋 Conceito

Para implementar a detecção precisa de áreas para colorir, você precisa criar **duas imagens**:

1. **Imagem Principal** - A que o usuário vê (linhas pretas, fundo branco)
2. **Imagem de Máscara** - Idêntica, mas com cada área preenchida com uma cor sólida diferente

## 🎨 Mapa de Cores SIMPLIFICADO

**TODAS as áreas coloríveis = `#00FF00` (Verde puro)**

Agora é muito mais simples:
- **Sol** = `#00FF00` (Verde)
- **Nuvem 1** = `#00FF00` (Verde)
- **Nuvem 2** = `#00FF00` (Verde)
- **Arco-íris** = `#00FF00` (Verde)
- **Corpo da Arca** = `#00FF00` (Verde)
- **Cabana da Arca** = `#00FF00` (Verde)
- **Janela** = `#00FF00` (Verde)
- **Elefante** = `#00FF00` (Verde)
- **Macaco** = `#00FF00` (Verde)
- **Girafa** = `#00FF00` (Verde)
- **Leão** = `#00FF00` (Verde)
- **Zebra** = `#00FF00` (Verde)
- **Ovelha** = `#00FF00` (Verde)
- **Pássaro** = `#00FF00` (Verde)
- **Água** = `#00FF00` (Verde)
- **Troncos da Arca** = `#00FF00` (Verde)

**✨ VANTAGEM:** Você só precisa de UMA cor! Cada área distinta que você pintar com verde será detectada como uma área separada para colorir.

## 🛠️ Como Criar

### Opção 1: Photopea (Recomendado - Gratuito)

1. **Acesse:** [photopea.com](https://photopea.com)
2. **Abra a imagem:** `File` → `Open` (sua imagem original)
3. **Configure a cor:** Clique no quadrado de cor → Digite `#00FF00` → Enter
4. **Magic Wand (W):** Selecione uma área branca (ex: dentro do sol)
5. **Paint Bucket (G):** Clique na área selecionada para pintar de verde
6. **Repita para TODAS as áreas:** 
   - Magic Wand em nova área
   - Paint Bucket para pintar de verde
   - Continue até pintar todas as áreas coloríveis
7. **Salve:** `File` → `Export As` → `PNG` → Nome: `[Nome]_mask.png`

**⚡ DICA:** Agora você só precisa de UMA cor (verde) para todas as áreas! Muito mais rápido!

### Opção 2: Photoshop/GIMP
1. Abra a imagem original
2. Configure cor para `#00FF00` (verde)
3. Para cada área, use Magic Wand + Paint Bucket com a mesma cor verde
4. Salve como PNG

### Opção 3: IA
- Use **DALL-E**, **Midjourney** ou **Stable Diffusion**
- Prompt: "Create a coloring book mask image where each distinct area is filled with solid green color #00FF00"

## 📁 Estrutura de Arquivos

```
assets/
├── images/
│   ├── drawings/           # Imagens originais (preto e branco)
│   │   ├── A criação.png
│   │   ├── Arca de Noé.png
│   │   └── ...
│   └── masks/              # Imagens de máscara (coloridas)
│       ├── A criação_mask.png
│       ├── Arca de Noé_mask.png
│       └── ...
```

## 🔧 Implementação no Código

Após criar as máscaras, atualize o método `_getMaskPath()`:

```dart
String? _getMaskPath(String historiaId) {
  switch (historiaId) {
    case '1':
      return 'assets/images/masks/A criação_mask.png';
    case '2':
      return 'assets/images/masks/Arca de Noé_mask.png';
    // ... outros casos
    default:
      return null;
  }
}
```

## ✅ Teste

1. Crie as imagens de máscara
2. Coloque na pasta `assets/images/masks/`
3. Atualize o código
4. Teste tocando em diferentes áreas

## 💡 Dicas

- Use cores bem contrastantes para evitar confusão
- Mantenha as mesmas dimensões da imagem original
- Salve em PNG para preservar as cores exatas
- Teste com tolerância de cor (±50) para compensar compressão

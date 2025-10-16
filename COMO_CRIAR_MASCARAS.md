# Como Criar Imagens de Máscara para Colorir

## 📋 Conceito

Para implementar a detecção precisa de áreas para colorir, você precisa criar **duas imagens**:

1. **Imagem Principal** - A que o usuário vê (linhas pretas, fundo branco)
2. **Imagem de Máscara** - Idêntica, mas com cada área preenchida com uma cor sólida diferente

## 🎨 Mapa de Cores - CADA ÁREA UMA COR DIFERENTE

**⚠️ IMPORTANTE:** Use cores EXATAS para que cada área seja detectada corretamente!

**Consulte o arquivo `MAPA_CORES_MASCARA.md` para a tabela completa!**

Exemplo:
- **Sol** = `#FFFF00` (Amarelo puro)
- **Nuvem 1** = `#00FFFF` (Ciano)
- **Nuvem 2** = `#0080FF` (Azul claro)
- **Arco-íris** = `#FF00FF` (Magenta)
- **Corpo da Arca** = `#FF8000` (Laranja)
- **Girafa** = `#FFFF80` (Amarelo claro)
- **Leão** = `#FFC000` (Dourado)
- **Água** = `#0000FF` (Azul puro)
- **Pássaro** = `#00FF00` (Verde puro)

E assim por diante... **Cada elemento tem sua cor única!**

**✨ VANTAGEM:** Detecção precisa de cada área individual!

## 🛠️ Como Criar

### Opção 1: Photopea (Recomendado - Gratuito)

1. **Acesse:** [photopea.com](https://photopea.com)
2. **Abra a imagem:** `File` → `Open` (sua imagem original)
3. **Para CADA área do mapa de cores:**
   - **Configure a cor:** Clique no quadrado de cor → Digite a cor EXATA (ex: `FFFF00` para o sol) → Enter
   - **Magic Wand (W):** Selecione a área branca correspondente
   - **Paint Bucket (G):** Clique para pintar com a cor específica
   - **Verifique:** Use Eyedropper (I) para confirmar que a cor está correta
4. **Repita** para todas as 15 áreas do `MAPA_CORES_MASCARA.md`
5. **Salve:** `File` → `Export As` → `PNG` → Nome: `Arca de Noe_Mask.png`

**⚡ DICA IMPORTANTE:** 
- Copie e cole as cores EXATAS do `MAPA_CORES_MASCARA.md`
- Use o Eyedropper (I) para verificar cada cor antes de salvar
- NÃO use cores parecidas - precisam ser EXATAS!

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

import '../models/historia.dart';
import '../utils/image_mapping.dart';
import '../l10n/app_localizations.dart';

class HistoriasData {
  static List<Historia> obterHistorias([AppLocalizations? l10n]) {
    return [
      Historia(
        id: '1',
        titulo: l10n?.storyCreationTitle ?? 'A Criação do Mundo',
        descricao: l10n?.storyCreationDesc ?? 'No princípio, Deus criou o céu e a terra. Ele fez a luz, as estrelas, o sol e a lua. Criou as plantas, os animais e, por último, criou o homem e a mulher à sua imagem e semelhança.',
        imagemPath: ImageMapping.getStoryImagePath('1') ?? 'assets/images/stories/criacao.png',
        referenciaBiblica: 'Gênesis1 -2',
        desenhoId: 'desenho_1',
      ),
      Historia(
        id: '2',
        titulo: l10n?.storyNoahTitle ?? 'Noé e a Arca',
        descricao: l10n?.storyNoahDesc ?? 'Deus pediu a Noé para construir uma grande arca porque viria um dilúvio. Noé obedeceu e colocou sua família e um casal de cada animal dentro da arca. Depois da chuva, um lindo arco-íris apareceu no céu.',
        imagemPath: ImageMapping.getStoryImagePath('2') ?? 'assets/images/stories/noe.png',
        referenciaBiblica: 'Gênesis 6-9',
        desenhoId: 'desenho_2',
      ),
      Historia(
        id: '3',
        titulo: l10n?.storyDavidTitle ?? 'Davi e Golias',
        descricao: l10n?.storyDavidDesc ?? 'Davi era um jovem pastor que confiava em Deus. Quando o gigante Golias desafiou o povo de Deus, Davi enfrentou-o apenas com uma funda e cinco pedras. Com a ajuda de Deus, venceu o gigante.',
        imagemPath: ImageMapping.getStoryImagePath('3') ?? 'assets/images/stories/davi_golias.png',
        referenciaBiblica: '1 Samuel 17',
        desenhoId: 'desenho_3',
      ),
      Historia(
        id: '4',
        titulo: l10n?.storyJonahTitle ?? 'Jonas e o Grande Peixe',
        descricao: l10n?.storyJonahDesc ?? 'Deus pediu a Jonas para ir a Nínive, mas ele fugiu de barco. Houve uma tempestade e Jonas foi engolido por um grande peixe. Dentro do peixe, Jonas orou a Deus e foi perdoado. O peixe o vomitou na praia.',
        imagemPath: ImageMapping.getStoryImagePath('4') ?? 'assets/images/stories/jonas.png',
        referenciaBiblica: 'Jonas 1-4',
        desenhoId: 'desenho_4',
      ),
      Historia(
        id: '5',
        titulo: l10n?.storyDanielTitle ?? 'Daniel na Cova dos Leões',
        descricao: l10n?.storyDanielDesc ?? 'Daniel orava a Deus todos os dias. Por isso, foi jogado em uma cova cheia de leões famintos. Mas Deus enviou um anjo que fechou a boca dos leões, e Daniel ficou em segurança a noite toda.',
        imagemPath: ImageMapping.getStoryImagePath('5') ?? 'assets/images/stories/daniel.png',
        referenciaBiblica: 'Daniel 6',
        desenhoId: 'desenho_5',
      ),
      Historia(
        id: '6',
        titulo: l10n?.storyJesusTitle ?? 'O Nascimento de Jesus',
        descricao: l10n?.storyJesusDesc ?? 'Maria e José foram a Belém. Lá, Jesus nasceu em uma manjedoura. Anjos apareceram aos pastores anunciando a boa notícia. Reis magos vieram de longe trazendo presentes para o menino Jesus.',
        imagemPath: ImageMapping.getStoryImagePath('6') ?? 'assets/images/stories/nascimento_jesus.png',
        referenciaBiblica: 'Lucas 2',
        desenhoId: 'desenho_6',
      ),
      Historia(
        id: '7',
        titulo: 'Jesus Acalma a Tempestade',
        descricao: 'Jesus e seus discípulos estavam em um barco quando uma grande tempestade começou. Os discípulos ficaram com medo, mas Jesus levantou-se e disse ao vento e às ondas: "Acalmem-se!" E tudo ficou calmo.',
        imagemPath: ImageMapping.getStoryImagePath('7') ?? 'assets/images/stories/tempestade.png',
        referenciaBiblica: 'Marcos 4:35-41',
        desenhoId: 'desenho_7',
      ),
      Historia(
        id: '8',
        titulo: 'A Multiplicação dos Pães e Peixes',
        descricao: 'Uma multidão seguia Jesus. Um menino tinha cinco pães e dois peixes. Jesus abençoou o alimento e multiplicou, alimentando mais de cinco mil pessoas. Ainda sobraram doze cestos!',
        imagemPath: ImageMapping.getStoryImagePath('8') ?? 'assets/images/stories/multiplicacao.png',
        referenciaBiblica: 'João 6:1-14',
        desenhoId: 'desenho_8',
      ),
      Historia(
        id: '9',
        titulo: 'O Bom Samaritano',
        descricao: 'Um homem foi assaltado e deixado ferido na estrada. Muitos passaram sem ajudar. Mas um samaritano parou, cuidou dele e o levou para uma hospedaria. Jesus ensina que devemos amar e ajudar todos.',
        imagemPath: ImageMapping.getStoryImagePath('9') ?? 'assets/images/stories/samaritano.png',
        referenciaBiblica: 'Lucas 10:25-37',
        desenhoId: 'desenho_9',
      ),
      Historia(
        id: '10',
        titulo: 'Zaqueu na Árvore',
        descricao: 'Zaqueu era baixinho e subiu em uma árvore para ver Jesus passar. Jesus o viu e disse: "Zaqueu, desça! Hoje vou ficar na sua casa!" Zaqueu ficou muito feliz e mudou sua vida.',
        imagemPath: ImageMapping.getStoryImagePath('10') ?? 'assets/images/stories/zaqueu.png',
        referenciaBiblica: 'Lucas 19:1-10',
        desenhoId: 'desenho_10',
      ),
      Historia(
        id: '11',
        titulo: 'A Tentação de Jesus no Deserto',
        descricao: 'Depois do batismo, Jesus foi levado pelo Espírito Santo ao deserto, onde ficou 40 dias sem comer. Satanás apareceu para tentá-Lo três vezes: transformar pedras em pão, pular do templo e adorar o diabo em troca de poder. Jesus resistiu a todas as tentações usando a Palavra de Deus, mostrando que devemos confiar em Deus acima de tudo.',
        descricaoCompleta: 'Depois que Jesus foi batizado por João Batista no rio Jordão, o Espírito Santo O guiou até o deserto. Ele ficou 40 dias e 40 noites lá, sem comer nada, orando e se preparando para a missão que Deus havia lhe dado.\n\nQuando Ele estava com muita fome, Satanás apareceu para tentar Jesus.\n\n😈 Primeira Tentação – Transformar pedras em pão\nO diabo disse: "Se tu és o Filho de Deus, manda que estas pedras se transformem em pães."\nMas Jesus respondeu com firmeza: "Está escrito: Nem só de pão viverá o homem, mas de toda palavra que sai da boca de Deus." (Deuteronômio 8:3)\n\n👉 Lição: Jesus mostrou que o mais importante não é a comida, mas confiar em Deus e em Sua Palavra.\n\n😈 Segunda Tentação – Pular do alto do templo\nEntão Satanás levou Jesus até a parte mais alta do templo em Jerusalém e disse: "Se tu és o Filho de Deus, lança-te daqui abaixo, porque está escrito: \'Aos seus anjos dará ordens a teu respeito, e eles te sustentarão com as mãos.\'"\nMas Jesus respondeu: "Também está escrito: Não tentarás o Senhor teu Deus." (Deuteronômio 6:16)\n\n👉 Lição: Não devemos testar o poder de Deus nem agir com orgulho, achando que Ele precisa provar algo pra nós.\n\n😈 Terceira Tentação – Poder e riquezas do mundo\nDepois, o diabo levou Jesus para um monte muito alto, mostrou todos os reinos do mundo e disse: "Tudo isso te darei, se prostrado me adorares."\nEntão Jesus ordenou: "Vai-te, Satanás! Porque está escrito: \'Ao Senhor teu Deus adorarás, e só a Ele servirás.\'" (Deuteronômio 6:13)\n\n👉 Lição: Jesus nos ensina que somente Deus merece adoração — nada neste mundo vale mais do que servir a Ele.\n\n🕊️ Vitória e Consolação\nApós essas três tentações, o diabo foi embora, derrotado. Então anjos vieram e serviram Jesus, trazendo conforto e alimento.',
        imagemPath: ImageMapping.getStoryImagePath('11') ?? 'assets/images/stories/Tentacao_deserto_Colorido.png',
        referenciaBiblica: 'Mateus 4:1-11',
        desenhoId: 'desenho_11',
      ),
    ];
  }
}


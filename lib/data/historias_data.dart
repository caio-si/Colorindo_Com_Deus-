import '../models/historia.dart';
import '../utils/image_mapping.dart';

class HistoriasData {
  static List<Historia> obterHistorias() {
    return [
      Historia(
        id: '1',
        titulo: 'A Criação do Mundo',
        descricao: 'No princípio, Deus criou o céu e a terra. Ele fez a luz, as estrelas, o sol e a lua. Criou as plantas, os animais e, por último, criou o homem e a mulher à sua imagem e semelhança.',
        imagemPath: ImageMapping.getStoryImagePath('1') ?? 'assets/images/stories/criacao.png',
        referenciaBiblica: 'Gênesis1 -2',
        desenhoId: 'desenho_1',
      ),
      Historia(
        id: '2',
        titulo: 'Noé e a Arca',
        descricao: 'Deus pediu a Noé para construir uma grande arca porque viria um dilúvio. Noé obedeceu e colocou sua família e um casal de cada animal dentro da arca. Depois da chuva, um lindo arco-íris apareceu no céu.',
        imagemPath: ImageMapping.getStoryImagePath('2') ?? 'assets/images/stories/noe.png',
        referenciaBiblica: 'Gênesis 6-9',
        desenhoId: 'desenho_2',
      ),
      Historia(
        id: '3',
        titulo: 'Davi e Golias',
        descricao: 'Davi era um jovem pastor que confiava em Deus. Quando o gigante Golias desafiou o povo de Deus, Davi enfrentou-o apenas com uma funda e cinco pedras. Com a ajuda de Deus, venceu o gigante.',
        imagemPath: ImageMapping.getStoryImagePath('3') ?? 'assets/images/stories/davi_golias.png',
        referenciaBiblica: '1 Samuel 17',
        desenhoId: 'desenho_3',
      ),
      Historia(
        id: '4',
        titulo: 'Jonas e o Grande Peixe',
        descricao: 'Deus pediu a Jonas para ir a Nínive, mas ele fugiu de barco. Houve uma tempestade e Jonas foi engolido por um grande peixe. Dentro do peixe, Jonas orou a Deus e foi perdoado. O peixe o vomitou na praia.',
        imagemPath: ImageMapping.getStoryImagePath('4') ?? 'assets/images/stories/jonas.png',
        referenciaBiblica: 'Jonas 1-4',
        desenhoId: 'desenho_4',
      ),
      Historia(
        id: '5',
        titulo: 'Daniel na Cova dos Leões',
        descricao: 'Daniel orava a Deus todos os dias. Por isso, foi jogado em uma cova cheia de leões famintos. Mas Deus enviou um anjo que fechou a boca dos leões, e Daniel ficou em segurança a noite toda.',
        imagemPath: ImageMapping.getStoryImagePath('5') ?? 'assets/images/stories/daniel.png',
        referenciaBiblica: 'Daniel 6',
        desenhoId: 'desenho_5',
      ),
      Historia(
        id: '6',
        titulo: 'O Nascimento de Jesus',
        descricao: 'Maria e José foram a Belém. Lá, Jesus nasceu em uma manjedoura. Anjos apareceram aos pastores anunciando a boa notícia. Reis magos vieram de longe trazendo presentes para o menino Jesus.',
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
    ];
  }
}


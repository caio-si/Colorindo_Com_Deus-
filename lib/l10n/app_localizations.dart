import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'pt_BR': {
      'app_name': 'Colorindo com Deus',
      'home_title': 'Bem-vindo!',
      'start_coloring': 'Começar a Colorir',
      'stories': 'Histórias',
      'gallery': 'Galeria',
      'settings': 'Configurações',
      'about': 'Sobre',
      'select_drawing': 'Escolha um Desenho',
      'coloring': 'Colorindo',
      'color_palette': 'Paleta de Cores',
      'undo': 'Desfazer',
      'redo': 'Refazer',
      'erase': 'Apagar',
      'save': 'Salvar',
      'finish': 'Finalizar',
      'biblical_stories': 'Histórias Bíblicas',
      'color_this_story': 'Colorir essa História',
      'my_gallery': 'Minha Galeria',
      'finished_drawings': 'Desenhos Finalizados',
      'in_progress': 'Em Andamento',
      'share': 'Compartilhar',
      'recolor': 'Recolorir',
      'delete': 'Excluir',
      'language': 'Idioma',
      'audio': 'Áudio',
      'sounds': 'Sons',
      'sounds_subtitle': 'Efeitos sonoros ao pintar',
      'narration': 'Narração',
      'narration_subtitle': 'Narração das histórias',
      'child_mode': 'Modo Infantil',
      'appearance': 'Aparência',
      'dark_mode': 'Modo Escuro',
      'dark_mode_subtitle': 'Tema escuro',
      'storage': 'Armazenamento',
      'clear_storage': 'Limpar Armazenamento',
      'clear_storage_subtitle': 'Apagar todos os desenhos salvos',
      'congratulations': 'Parabéns!',
      'drawing_completed': 'Você terminou este desenho!',
      'verse_prize': 'Versículo de Prêmio',
      'no_drawings': 'Nenhum desenho ainda',
      'start_coloring_now': 'Comece a colorir agora!',
      // Historias Bíblicas
      'story_creation_title': 'A Criação do Mundo',
      'story_creation_desc': 'No princípio, Deus criou o céu e a terra. Ele fez a luz, as estrelas, o sol e a lua. Criou as plantas, os animais e, por último, criou o homem e a mulher à sua imagem e semelhança.',
      'story_noah_title': 'Noé e a Arca',
      'story_noah_desc': 'Deus pediu a Noé para construir uma grande arca porque viria um dilúvio. Noé obedeceu e colocou sua família e um casal de cada animal dentro da arca. Depois da chuva, um lindo arco-íris apareceu no céu.',
      'story_david_title': 'Davi e Golias',
      'story_david_desc': 'Davi era um jovem pastor que confiava em Deus. Quando o gigante Golias desafiou o povo de Deus, Davi enfrentou-o apenas com uma funda e cinco pedras. Com a ajuda de Deus, venceu o gigante.',
      'story_jonah_title': 'Jonas e o Grande Peixe',
      'story_jonah_desc': 'Deus pediu a Jonas para ir a Nínive, mas ele fugiu de barco. Houve uma tempestade e Jonas foi engolido por um grande peixe. Dentro do peixe, Jonas orou a Deus e foi perdoado. O peixe o vomitou na praia.',
      'story_daniel_title': 'Daniel na Cova dos Leões',
      'story_daniel_desc': 'Daniel orava a Deus todos os dias. Por isso, foi jogado em uma cova cheia de leões famintos. Mas Deus enviou um anjo que fechou a boca dos leões, e Daniel ficou em segurança a noite toda.',
      'story_jesus_title': 'O Nascimento de Jesus',
      'story_jesus_desc': 'Maria e José foram a Belém. Lá, Jesus nasceu em uma manjedoura. Anjos apareceram aos pastores anunciando a boa notícia. Reis magos vieram de longe trazendo presentes para o menino Jesus.',
      'story_multiplication_title': 'A Multiplicação dos Pães e Peixes',
      'story_multiplication_desc': 'Jesus estava ensinando uma grande multidão. Quando chegou a hora de comer, havia apenas cinco pães e dois peixes. Jesus abençoou a comida e ela se multiplicou, alimentando todos com sobras.',
      'story_last_supper_title': 'A Última Ceia',
      'story_last_supper_desc': 'Jesus se reuniu com seus discípulos para a ceia da Páscoa. Ele pegou pão e vinho, abençoou-os e disse: "Este é meu corpo e sangue. Façam isso em memória de mim."',
      'story_crucifixion_title': 'A Crucificação de Jesus',
      'story_crucifixion_desc': 'Jesus foi crucificado em uma cruz para salvar a humanidade. Mesmo com dor, ele perdoou aqueles que o crucificaram. Após três dias, ele ressuscitou dos mortos, mostrando seu poder sobre a morte.',
      'story_resurrection_title': 'A Ressurreição de Jesus',
      'story_resurrection_desc': 'No terceiro dia, Jesus ressuscitou dos mortos. O túmulo estava vazio e anjos anunciaram: "Ele não está aqui, ressuscitou!" Este é o maior milagre que mostra o amor de Deus por nós.',
    },
    'en_US': {
      'app_name': 'Coloring with God',
      'home_title': 'Welcome!',
      'start_coloring': 'Start Coloring',
      'stories': 'Stories',
      'gallery': 'Gallery',
      'settings': 'Settings',
      'about': 'About',
      'select_drawing': 'Choose a Drawing',
      'coloring': 'Coloring',
      'color_palette': 'Color Palette',
      'undo': 'Undo',
      'redo': 'Redo',
      'erase': 'Erase',
      'save': 'Save',
      'finish': 'Finish',
      'biblical_stories': 'Biblical Stories',
      'color_this_story': 'Color this Story',
      'my_gallery': 'My Gallery',
      'finished_drawings': 'Finished Drawings',
      'in_progress': 'In Progress',
      'share': 'Share',
      'recolor': 'Recolor',
      'delete': 'Delete',
      'language': 'Language',
      'audio': 'Audio',
      'sounds': 'Sounds',
      'sounds_subtitle': 'Sound effects when painting',
      'narration': 'Narration',
      'narration_subtitle': 'Story narration',
      'child_mode': 'Child Mode',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'dark_mode_subtitle': 'Dark theme',
      'storage': 'Storage',
      'clear_storage': 'Clear Storage',
      'clear_storage_subtitle': 'Delete all saved drawings',
      'congratulations': 'Congratulations!',
      'drawing_completed': 'You completed this drawing!',
      'verse_prize': 'Prize Verse',
      'no_drawings': 'No drawings yet',
      'start_coloring_now': 'Start coloring now!',
      // Biblical Stories
      'story_creation_title': 'The Creation of the World',
      'story_creation_desc': 'In the beginning, God created the heavens and the earth. He made light, stars, sun and moon. He created plants, animals and, finally, created man and woman in his image and likeness.',
      'story_noah_title': 'Noah and the Ark',
      'story_noah_desc': 'God asked Noah to build a great ark because a flood would come. Noah obeyed and put his family and a pair of each animal inside the ark. After the rain, a beautiful rainbow appeared in the sky.',
      'story_david_title': 'David and Goliath',
      'story_david_desc': 'David was a young shepherd who trusted in God. When the giant Goliath challenged God\'s people, David faced him with only a sling and five stones. With God\'s help, he defeated the giant.',
      'story_jonah_title': 'Jonah and the Big Fish',
      'story_jonah_desc': 'God asked Jonah to go to Nineveh, but he fled by boat. There was a storm and Jonah was swallowed by a big fish. Inside the fish, Jonah prayed to God and was forgiven. The fish vomited him on the beach.',
      'story_daniel_title': 'Daniel in the Lions\' Den',
      'story_daniel_desc': 'Daniel prayed to God every day. For this, he was thrown into a pit full of hungry lions. But God sent an angel who closed the lions\' mouths, and Daniel stayed safe all night.',
      'story_jesus_title': 'The Birth of Jesus',
      'story_jesus_desc': 'Mary and Joseph went to Bethlehem. There, Jesus was born in a manger. Angels appeared to the shepherds announcing the good news. Wise men came from afar bringing gifts for baby Jesus.',
      'story_multiplication_title': 'The Multiplication of Loaves and Fish',
      'story_multiplication_desc': 'Jesus was teaching a large crowd. When it was time to eat, there were only five loaves and two fish. Jesus blessed the food and it multiplied, feeding everyone with leftovers.',
      'story_last_supper_title': 'The Last Supper',
      'story_last_supper_desc': 'Jesus gathered with his disciples for the Passover meal. He took bread and wine, blessed them and said: "This is my body and blood. Do this in memory of me."',
      'story_crucifixion_title': 'The Crucifixion of Jesus',
      'story_crucifixion_desc': 'Jesus was crucified on a cross to save humanity. Even in pain, he forgave those who crucified him. After three days, he rose from the dead, showing his power over death.',
      'story_resurrection_title': 'The Resurrection of Jesus',
      'story_resurrection_desc': 'On the third day, Jesus rose from the dead. The tomb was empty and angels announced: "He is not here, he has risen!" This is the greatest miracle that shows God\'s love for us.',
    },
    'es_ES': {
      'app_name': 'Coloreando con Dios',
      'home_title': '¡Bienvenido!',
      'start_coloring': 'Empezar a Colorear',
      'stories': 'Historias',
      'gallery': 'Galería',
      'settings': 'Configuración',
      'about': 'Acerca de',
      'select_drawing': 'Elige un Dibujo',
      'coloring': 'Coloreando',
      'color_palette': 'Paleta de Colores',
      'undo': 'Deshacer',
      'redo': 'Rehacer',
      'erase': 'Borrar',
      'save': 'Guardar',
      'finish': 'Finalizar',
      'biblical_stories': 'Historias Bíblicas',
      'color_this_story': 'Colorear esta Historia',
      'my_gallery': 'Mi Galería',
      'finished_drawings': 'Dibujos Terminados',
      'in_progress': 'En Progreso',
      'share': 'Compartir',
      'recolor': 'Recolorear',
      'delete': 'Eliminar',
      'language': 'Idioma',
      'audio': 'Audio',
      'sounds': 'Sonidos',
      'sounds_subtitle': 'Efectos de sonido al pintar',
      'narration': 'Narración',
      'narration_subtitle': 'Narración de historias',
      'child_mode': 'Modo Infantil',
      'appearance': 'Apariencia',
      'dark_mode': 'Modo Oscuro',
      'dark_mode_subtitle': 'Tema oscuro',
      'storage': 'Almacenamiento',
      'clear_storage': 'Limpiar Almacenamiento',
      'clear_storage_subtitle': 'Eliminar todos los dibujos guardados',
      'congratulations': '¡Felicidades!',
      'drawing_completed': '¡Completaste este dibujo!',
      'verse_prize': 'Versículo de Premio',
      'no_drawings': 'Aún no hay dibujos',
      'start_coloring_now': '¡Empieza a colorear ahora!',
      // Historias Bíblicas
      'story_creation_title': 'La Creación del Mundo',
      'story_creation_desc': 'En el principio, Dios creó los cielos y la tierra. Hizo la luz, las estrellas, el sol y la luna. Creó las plantas, los animales y, por último, creó al hombre y la mujer a su imagen y semejanza.',
      'story_noah_title': 'Noé y el Arca',
      'story_noah_desc': 'Dios pidió a Noé que construyera un gran arca porque vendría un diluvio. Noé obedeció y puso a su familia y una pareja de cada animal dentro del arca. Después de la lluvia, apareció un hermoso arcoíris en el cielo.',
      'story_david_title': 'David y Goliat',
      'story_david_desc': 'David era un joven pastor que confiaba en Dios. Cuando el gigante Goliat desafió al pueblo de Dios, David lo enfrentó solo con una honda y cinco piedras. Con la ayuda de Dios, venció al gigante.',
      'story_jonah_title': 'Jonás y el Gran Pez',
      'story_jonah_desc': 'Dios pidió a Jonás que fuera a Nínive, pero él huyó en barco. Hubo una tormenta y Jonás fue tragado por un gran pez. Dentro del pez, Jonás oró a Dios y fue perdonado. El pez lo vomitó en la playa.',
      'story_daniel_title': 'Daniel en el Foso de los Leones',
      'story_daniel_desc': 'Daniel oraba a Dios todos los días. Por eso, fue arrojado a un foso lleno de leones hambrientos. Pero Dios envió un ángel que cerró la boca de los leones, y Daniel se mantuvo a salvo toda la noche.',
      'story_jesus_title': 'El Nacimiento de Jesús',
      'story_jesus_desc': 'María y José fueron a Belén. Allí, Jesús nació en un pesebre. Los ángeles aparecieron a los pastores anunciando la buena noticia. Los reyes magos vinieron de lejos trayendo regalos para el niño Jesús.',
      'story_multiplication_title': 'La Multiplicación de los Panes y Peces',
      'story_multiplication_desc': 'Jesús estaba enseñando a una gran multitud. Cuando llegó la hora de comer, solo había cinco panes y dos peces. Jesús bendijo la comida y se multiplicó, alimentando a todos con sobras.',
      'story_last_supper_title': 'La Última Cena',
      'story_last_supper_desc': 'Jesús se reunió con sus discípulos para la cena de Pascua. Tomó pan y vino, los bendijo y dijo: "Este es mi cuerpo y sangre. Hagan esto en memoria mía."',
      'story_crucifixion_title': 'La Crucifixión de Jesús',
      'story_crucifixion_desc': 'Jesús fue crucificado en una cruz para salvar a la humanidad. Incluso en el dolor, perdonó a quienes lo crucificaron. Después de tres días, resucitó de entre los muertos, mostrando su poder sobre la muerte.',
      'story_resurrection_title': 'La Resurrección de Jesús',
      'story_resurrection_desc': 'Al tercer día, Jesús resucitó de entre los muertos. La tumba estaba vacía y los ángeles anunciaron: "¡No está aquí, ha resucitado!" Este es el milagro más grande que muestra el amor de Dios por nosotros.',
    },
  };

  String translate(String key) {
    final localeKey = '${locale.languageCode}_${locale.countryCode}';
    return _localizedValues[localeKey]?[key] ?? key;
  }

  String get appName => translate('app_name');
  String get homeTitle => translate('home_title');
  String get startColoring => translate('start_coloring');
  String get stories => translate('stories');
  String get gallery => translate('gallery');
  String get settings => translate('settings');
  String get about => translate('about');
  String get selectDrawing => translate('select_drawing');
  String get coloring => translate('coloring');
  String get colorPalette => translate('color_palette');
  String get undo => translate('undo');
  String get redo => translate('redo');
  String get erase => translate('erase');
  String get save => translate('save');
  String get finish => translate('finish');
  String get biblicalStories => translate('biblical_stories');
  String get colorThisStory => translate('color_this_story');
  String get myGallery => translate('my_gallery');
  String get finishedDrawings => translate('finished_drawings');
  String get inProgress => translate('in_progress');
  String get share => translate('share');
  String get recolor => translate('recolor');
  String get delete => translate('delete');
  String get language => translate('language');
  String get audio => translate('audio');
  String get sounds => translate('sounds');
  String get soundsSubtitle => translate('sounds_subtitle');
  String get narration => translate('narration');
  String get narrationSubtitle => translate('narration_subtitle');
  String get childMode => translate('child_mode');
  String get appearance => translate('appearance');
  String get darkMode => translate('dark_mode');
  String get darkModeSubtitle => translate('dark_mode_subtitle');
  String get storage => translate('storage');
  String get clearStorage => translate('clear_storage');
  String get clearStorageSubtitle => translate('clear_storage_subtitle');
  String get congratulations => translate('congratulations');
  String get drawingCompleted => translate('drawing_completed');
  String get versePrize => translate('verse_prize');
  String get noDrawings => translate('no_drawings');
  String get startColoringNow => translate('start_coloring_now');
  
  // Biblical Stories
  String get storyCreationTitle => translate('story_creation_title');
  String get storyCreationDesc => translate('story_creation_desc');
  String get storyNoahTitle => translate('story_noah_title');
  String get storyNoahDesc => translate('story_noah_desc');
  String get storyDavidTitle => translate('story_david_title');
  String get storyDavidDesc => translate('story_david_desc');
  String get storyJonahTitle => translate('story_jonah_title');
  String get storyJonahDesc => translate('story_jonah_desc');
  String get storyDanielTitle => translate('story_daniel_title');
  String get storyDanielDesc => translate('story_daniel_desc');
  String get storyJesusTitle => translate('story_jesus_title');
  String get storyJesusDesc => translate('story_jesus_desc');
  String get storyMultiplicationTitle => translate('story_multiplication_title');
  String get storyMultiplicationDesc => translate('story_multiplication_desc');
  String get storyLastSupperTitle => translate('story_last_supper_title');
  String get storyLastSupperDesc => translate('story_last_supper_desc');
  String get storyCrucifixionTitle => translate('story_crucifixion_title');
  String get storyCrucifixionDesc => translate('story_crucifixion_desc');
  String get storyResurrectionTitle => translate('story_resurrection_title');
  String get storyResurrectionDesc => translate('story_resurrection_desc');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['pt', 'en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}


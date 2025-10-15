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
      'sounds': 'Sons',
      'narration': 'Narração',
      'child_mode': 'Modo Infantil',
      'dark_mode': 'Modo Escuro',
      'clear_storage': 'Limpar Armazenamento',
      'congratulations': 'Parabéns!',
      'drawing_completed': 'Você terminou este desenho!',
      'verse_prize': 'Versículo de Prêmio',
      'no_drawings': 'Nenhum desenho ainda',
      'start_coloring_now': 'Comece a colorir agora!',
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
      'sounds': 'Sounds',
      'narration': 'Narration',
      'child_mode': 'Child Mode',
      'dark_mode': 'Dark Mode',
      'clear_storage': 'Clear Storage',
      'congratulations': 'Congratulations!',
      'drawing_completed': 'You completed this drawing!',
      'verse_prize': 'Prize Verse',
      'no_drawings': 'No drawings yet',
      'start_coloring_now': 'Start coloring now!',
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
      'sounds': 'Sonidos',
      'narration': 'Narración',
      'child_mode': 'Modo Infantil',
      'dark_mode': 'Modo Oscuro',
      'clear_storage': 'Limpiar Almacenamiento',
      'congratulations': '¡Felicidades!',
      'drawing_completed': '¡Completaste este dibujo!',
      'verse_prize': 'Versículo de Premio',
      'no_drawings': 'Aún no hay dibujos',
      'start_coloring_now': '¡Empieza a colorear ahora!',
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
  String get sounds => translate('sounds');
  String get narration => translate('narration');
  String get childMode => translate('child_mode');
  String get darkMode => translate('dark_mode');
  String get clearStorage => translate('clear_storage');
  String get congratulations => translate('congratulations');
  String get drawingCompleted => translate('drawing_completed');
  String get versePrize => translate('verse_prize');
  String get noDrawings => translate('no_drawings');
  String get startColoringNow => translate('start_coloring_now');
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


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  final Box _box = Hive.box('settings');
  
  late Locale _currentLocale;
  late bool _soundsEnabled;
  late bool _narrationEnabled;
  late bool _childMode;

  SettingsProvider() {
    _loadSettings();
  }

  Locale get currentLocale => _currentLocale;
  bool get soundsEnabled => _soundsEnabled;
  bool get narrationEnabled => _narrationEnabled;
  bool get childMode => _childMode;

  void _loadSettings() {
    final languageCode = _box.get('languageCode', defaultValue: 'pt');
    final countryCode = _box.get('countryCode', defaultValue: 'BR');
    _currentLocale = Locale(languageCode, countryCode);
    
    _soundsEnabled = _box.get('soundsEnabled', defaultValue: true);
    _narrationEnabled = _box.get('narrationEnabled', defaultValue: true);
    _childMode = _box.get('childMode', defaultValue: true);
    
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _currentLocale = locale;
    await _box.put('languageCode', locale.languageCode);
    await _box.put('countryCode', locale.countryCode ?? '');
    notifyListeners();
  }

  Future<void> toggleSounds() async {
    _soundsEnabled = !_soundsEnabled;
    await _box.put('soundsEnabled', _soundsEnabled);
    notifyListeners();
  }

  Future<void> toggleNarration() async {
    _narrationEnabled = !_narrationEnabled;
    await _box.put('narrationEnabled', _narrationEnabled);
    notifyListeners();
  }

  Future<void> toggleChildMode() async {
    _childMode = !_childMode;
    await _box.put('childMode', _childMode);
    notifyListeners();
  }

  Future<void> clearStorage() async {
    final galleryBox = Hive.box('gallery');
    final progressBox = Hive.box('progress');
    await galleryBox.clear();
    await progressBox.clear();
    notifyListeners();
  }
}


import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

abstract class LocalStorageService {
  Future<void> saveLanguage(String language);

  Future<String?> getLanguage();
}

class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences prefs;

  LocalStorageServiceImpl(this.prefs);

  @override
  Future<void> saveLanguage(String language) async {
    await prefs.setString(
      StorageKeys.language,
      language,
    );
  }

  @override
  Future<String?> getLanguage() async {
    return prefs.getString(
      StorageKeys.language,
    );
  }
}
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value);
  Future<void> remove(String key);
}

@Singleton(as: LocalStorage)
class SharedPreferencesAdapter implements LocalStorage {
  Future<SharedPreferences> getPrefs() {
    return SharedPreferences.getInstance();
  }

  @override
  Future<T?> get<T>(String key) async {
    final prefs = await getPrefs();
    return prefs.get(key) as T?;
  }

  @override
  Future<void> set<T>(String key, T value) async {
    final prefs = await getPrefs();
    switch (value) {
      case int():
        await prefs.setInt(key, value as int);
        break;
      case bool():
        await prefs.setBool(key, value as bool);
        break;
      case double():
        await prefs.setDouble(key, value as double);
        break;
      case String():
        await prefs.setString(key, value as String);
      case List<String>():
        await prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw StateError('Unsupported type: $T');
    }
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await getPrefs();
    await prefs.remove(key);
  }
}

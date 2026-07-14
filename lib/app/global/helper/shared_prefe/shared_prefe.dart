import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceValue {
  static const String searchHistory = "searchHistory";
  static const String token = "token";
  static const String email = "email";
  static const String isRemember = "isRemember";
  static const String isOnboarding = "isOnboarding";
  static const String isSubscribed = "is_subscribed";
  static const String activeProductId = "active_product_id";
}

class SharePrefsHelper {
  //===========================Get Data From Shared Preference===================

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(key) ?? "";
  }

  static Future<List<String>> getLisOfString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var getListData = preferences.getStringList(key);

    return getListData!;
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getBool(key);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? (-1);
  }

//===========================Save Data To Shared Preference===================

  static Future setString(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static Future<bool> setListOfString(String key, List<String> value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var setListData = await preferences.setStringList(key, value);

    return setListData;
  }

  static Future setBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

//===========================Remove Value===================

  static Future remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }

  //===========================Save House and Room===================
  static const String _selectedHouseIdKey = 'selectedHouseId';
  static const String _selectedHouseNameKey = 'selectedHouseName';

  static const String _selectedRoomIdKey = 'selectedRoomId';
  static const String _selectedRoomNameKey = 'selectedRoomName';

  /// ✅ Save House
  static Future<void> saveSelectedHouse(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedHouseIdKey, id);
    await prefs.setString(_selectedHouseNameKey, name);
  }

  static Future<String?> getSelectedHouseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedHouseIdKey);
  }

  static Future<String?> getSelectedHouseName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedHouseNameKey);
  }

  /// ✅ Save Room (Optional)
  static Future<void> saveSelectedRoom(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedRoomIdKey, id);
    await prefs.setString(_selectedRoomNameKey, name);
  }

  static Future<String?> getSelectedRoomId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedRoomIdKey);
  }

  static Future<String?> getSelectedRoomName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedRoomNameKey);
  }

  /// ❌ Clear all
  static Future<void> clearSelections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedHouseIdKey);
    await prefs.remove(_selectedHouseNameKey);
    await prefs.remove(_selectedRoomIdKey);
    await prefs.remove(_selectedRoomNameKey);
  }
}

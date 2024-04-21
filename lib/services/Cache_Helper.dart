import 'package:shared_preferences/shared_preferences.dart';
class CacheData{
  static late SharedPreferences sharedPreferences;
  static Future<void> cacheInitialization()async{
    sharedPreferences =await SharedPreferences.getInstance();
  }
  static void setData({required String key,required dynamic value })async{
    await sharedPreferences.setString(key, value);
  }
  static dynamic getData({required String key}){
    return sharedPreferences.get(key);
  }
  static void deleteItem({required String key}){
    sharedPreferences.remove(key);
  }
}
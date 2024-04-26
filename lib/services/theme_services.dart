import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices{
  final _box = GetStorage();
  final _key = 'isdarkmode';

  _saveThemeToBox (bool isDarkMode)=>_box.write(_key, isDarkMode);
  bool _loadthemeFromBox()=>_box.read(_key)??false;
  ThemeMode get theme=>_loadthemeFromBox()?ThemeMode.dark:ThemeMode.light;
  void switchTheme(){
    Get.changeThemeMode(_loadthemeFromBox()?ThemeMode.light:ThemeMode.dark);
    _saveThemeToBox (!_loadthemeFromBox());
  }
}

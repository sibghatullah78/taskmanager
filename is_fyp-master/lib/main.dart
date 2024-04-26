import 'package:flutter/material.dart';
import 'package:is_fyp/db_helper/db_helper.dart';
import 'package:is_fyp/services/theme_services.dart';
import 'package:is_fyp/ui/home_page.dart';
import 'package:is_fyp/ui/profile_provider.dart';
import 'package:is_fyp/ui/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'Authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeServices().theme,

        home: HomePage(),
     // home: HomePage(),

    );
  }
}

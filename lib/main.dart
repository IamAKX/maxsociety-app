import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/appintro/app_intro_screen.dart';
import 'package:maxsociety/service/api_service.dart';
import 'package:maxsociety/service/auth_service.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/util/router.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/main_container.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (prefs.containsKey(PreferenceKey.user)) {
    UserProfile userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
    UserProfile user = await ApiProvider.instance.getUserById(userProfile.userId!);
    prefs.setString(PreferenceKey.user, user.toJson());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ApiProvider(),
        )
      ],
      child: MaterialApp(
        title: 'MaxSociety',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: NavRoute.generatedRoute,
        theme: globalTheme(context),
        home: getStartUpScreen(),
      ),
    );
  }

  getStartUpScreen() {
    if (prefs.containsKey(PreferenceKey.user) &&
        (prefs.getString(PreferenceKey.user)?.isNotEmpty ?? false)) {
      return const MainContainer();
    } else {
      return const AppIntroScreen();
    }
  }
}

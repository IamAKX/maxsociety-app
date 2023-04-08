import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maxsociety/model/app_metadata_model.dart';
import 'package:maxsociety/model/society_model.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/appintro/app_intro_screen.dart';
import 'package:maxsociety/service/api_service.dart';
import 'package:maxsociety/service/auth_service.dart';
import 'package:maxsociety/service/db_service.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/util/router.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/main_container.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

late SharedPreferences prefs;
AppMetadataModel? appMetadata;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (prefs.containsKey(PreferenceKey.user)) {
  //   UserProfile userProfile =
  //       UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
  //   UserProfile user =
  //       await ApiProvider.instance.getUserById(userProfile.userId!);
  //   prefs.setString(PreferenceKey.user, user.toJson());
  // }
  await setupFirebaseMessaging();

  SocietyModel societyModel = await ApiProvider.instance.getSociety();
  prefs.setString(PreferenceKey.society, societyModel.toJson());
  await DBService.instance.getAppMetadata();
  if (prefs.containsKey(PreferenceKey.metadata)) {
    appMetadata =
        AppMetadataModel.fromJson(prefs.getString(PreferenceKey.metadata)!);
  }

  runApp(const MyApp());
}

setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken;
  await messaging.getToken().then((value) {
    fcmToken = value;
    log('fcmToken : $fcmToken');
    prefs.setString(PreferenceKey.fcmToken, fcmToken ?? '');
  });

  if (prefs.containsKey(PreferenceKey.user)) {
    UserProfile userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
    userProfile.fcmToken = fcmToken ?? '';
    await ApiProvider.instance.updateUserSilently(userProfile);
    // UserProfile user =
    //     await ApiProvider.instance.getUserById(userProfile.userId!);
    // log(user.toJson());
    // prefs.setString(PreferenceKey.user, user.toJson());
  }

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      publishNotification(
          message.notification?.title ?? '', message.notification?.body ?? '');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['type'] == 'chat') {}
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  publishNotification(
      message.notification?.title ?? '', message.notification?.body ?? '');
}

Future<void> publishNotification(String title, String body) async {
  // var androidPlatformChannelSpecifics =
  //     const AndroidNotificationDetails('channel_ID_iamsmart', 'channel name',
  //         channelDescription: 'channel description',
  //         importance: Importance.max,
  //         playSound: true,
  //         // sound: RawResourceAndroidNotificationSound('ringtone'),
  //         showProgress: true,
  //         priority: Priority.high,
  //         ticker: 'test ticker');

  // var iOSChannelSpecifics = const DarwinNotificationDetails();
  // var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  // await flutterLocalNotificationsPlugin
  //     .show(0, title, body, platformChannelSpecifics, payload: 'test');
  if (navigatorKey.currentContext != null &&
      navigatorKey.currentState != null) {
    AwesomeDialog(
      context: navigatorKey.currentContext!,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: title,
      desc: body,
      autoDismiss: false,
      btnCancelText: 'Denied',
      btnOkText: 'Allow',
      btnCancelColor: Colors.red,
      btnOkColor: Colors.green,
      onDismissCallback: (type) {},
      btnCancelOnPress: () {
        navigatorKey.currentState!.pop();
      },
      btnOkOnPress: () {
        navigatorKey.currentState!.pop();
      },
    ).show();
  }
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
        navigatorKey: navigatorKey,
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

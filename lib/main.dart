import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maxsociety/model/app_metadata_model.dart';
import 'package:maxsociety/model/society_model.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/appintro/app_intro_screen.dart';
import 'package:maxsociety/screen/security_guard/guard_main_container.dart';
import 'package:maxsociety/service/api_service.dart';
import 'package:maxsociety/service/auth_service.dart';
import 'package:maxsociety/service/db_service.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/util/router.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/main_container.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'model/visitors_record_model.dart';

late SharedPreferences prefs;
UserProfile? _userProfile;
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
  while (!await Permission.phone.request().isGranted) {
    Fluttertoast.showToast(
        msg: 'Please provide phone access to register the device',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }
  await setupFirebaseMessaging();
  log('FCM setup complete');
  SocietyModel societyModel = await ApiProvider.instance.getSociety();
  prefs.setString(PreferenceKey.society, societyModel.toJson());
  await DBService.instance.getAppMetadata();
  if (prefs.containsKey(PreferenceKey.metadata)) {
    appMetadata =
        AppMetadataModel.fromJson(prefs.getString(PreferenceKey.metadata)!);
  }

  runApp(const MyApp());
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken;
  await messaging.getToken().then((value) {
    fcmToken = value;
    log('fcmToken : $fcmToken');
    prefs.setString(PreferenceKey.fcmToken, fcmToken ?? '');
  });

  if (prefs.containsKey(PreferenceKey.user)) {
    _userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
    _userProfile?.fcmToken = fcmToken ?? '';
    await ApiProvider.instance.updateUserSilently(_userProfile!);
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
      log(message.toMap().toString());
      publishNotification(message.notification?.title ?? '',
          message.notification?.body ?? '', message.data);
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (prefs.containsKey(PreferenceKey.user) &&
        navigatorKey.currentContext != null &&
        navigatorKey.currentState != null) {
      Navigator.of(navigatorKey.currentContext!)
          .pushNamed(message.data['path']);
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  publishNotification(message.notification?.title ?? '',
      message.notification?.body ?? '', message.data);
}

Future<void> publishNotification(
    String title, String body, Map<String, dynamic> data) async {
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
    if (data['status'] != NotificationStatus.PENDING.name) {
      AwesomeDialog(
        context: navigatorKey.currentContext!,
        dialogType: getDialogType(data['status']),
        animType: AnimType.bottomSlide,
        title: title,
        desc: body,
        autoDismiss: false,
        btnOkText: 'Okay',
        btnCancelColor: Colors.red,
        btnOkColor: primaryColor,
        onDismissCallback: (type) {},
        btnOkOnPress: () {
          navigatorKey.currentState!.pop();
        },
      ).show();
    } else {
      AwesomeDialog(
        context: navigatorKey.currentContext!,
        dialogType: getDialogType(data['status']),
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
          VisiorsRecordModel reqBody = VisiorsRecordModel.fromMap(data);
          reqBody.status = NotificationStatus.REJECTED.name;
          reqBody.title = 'Entry is denied';
          reqBody.body = 'Do not permit ${reqBody.visitorName} to enter';
          ApiProvider.instance.sendVisitorNotification(reqBody.toMap());
        },
        btnOkOnPress: () {
          navigatorKey.currentState!.pop();
          VisiorsRecordModel reqBody = VisiorsRecordModel.fromMap(data);
          reqBody.status = NotificationStatus.APPROVED.name;
          reqBody.title = 'Entry is approved';
          reqBody.body = 'Please allow ${reqBody.visitorName} to enter';
          ApiProvider.instance.sendVisitorNotification(reqBody.toMap());
        },
      ).show();
    }
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
    if ((_userProfile?.roles?.isNotEmpty ?? false)) {
      if (_userProfile?.roles?.any((element) => element.id == 4) ?? false) {
        return const GuardMainContainer();
      } else {
        return const MainContainer();
      }
    } else {
      return const AppIntroScreen();
    }
  }
}

DialogType getDialogType(String status) {
  if (status == NotificationStatus.APPROVED.name) return DialogType.success;
  if (status == NotificationStatus.REJECTED.name) return DialogType.error;
  return DialogType.question;
}

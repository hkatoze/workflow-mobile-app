import 'dart:async';
 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/passerel.dart';
import 'package:workflow/services/apiservices.dart';
 
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:workflow/services/notificationservices.dart';
import 'package:workflow/services/update.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeBackgroundService();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();

  runApp(const MyApp());
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onStart,
    ),
  );
  await service.startService();
}

void updateNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var response = await getRequisitions(prefs.getString('companyId') ?? '',
      prefs.getString('department') ?? '', prefs.getString('maxAmount') ?? '');

  if (response.length > (prefs.getInt('oldRequisitionLength') ?? 0)) {
    NotificationService().showNotification(
        title: 'New Requisition',
        body:
            "Requester: ${response.last.requestBy}\n${response.last.description}");
  } else {
    print("OldLength: ${prefs.getInt(
      'oldRequisitionLength',
    )} \nNewLength: ${response.length}");
  }

  prefs.setInt('oldRequisitionLength', response.length);
}

void onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterBackgroundService().sendData({'action': 'start'});
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('email') == '' || prefs.getString('email') == null) {
  } else {
    Timer.periodic(Duration(seconds: 60), (Timer t) {
      updateRequisitionsOnFirebase();
      updateNotification();

      print(prefs.getString('email'));

      FlutterBackgroundService().sendData({'action': 'heartbeat'});
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Passerell(),
    );
  }
}

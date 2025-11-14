import 'package:Shopify/core/services/dio_provider2.dart';
import 'package:Shopify/core/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/firebase_notifi.dart';
import 'firebase_options.dart';


Future<void> main() async {
  DioProvider2.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeService = ThemeService();
  final firebaseNotificationService = FirebaseNotificationService();
  await firebaseNotificationService.initialize();

  runApp(MyApp( themeService: themeService));

}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


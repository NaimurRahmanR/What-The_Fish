```dart

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:permission_handler/permission_handler.dart';

import 'providers/fish_provider.dart';

import 'screens/splash_screen.dart';

import 'models/fish_identification.dart';

import 'utils/theme.dart';

void main() async {

WidgetsFlutterBinding.ensureInitialized();


// Initialize Hive

await Hive.initFlutter();

Hive.registerAdapter(FishIdentificationAdapter());


// Set system UI overlay style

SystemChrome.setSystemUIOverlayStyle(

const SystemUiOverlayStyle(

statusBarColor: Colors.transparent,

statusBarIconBrightness: Brightness.light,

),

);


// Request permissions

await _requestPermissions();


runApp(const WhatTheFishApp());

}

Future<void> _requestPermissions() async {

await [

Permission.camera,

Permission.storage,

Permission.photos,

].request();

}

class WhatTheFishApp extends StatelessWidget {

const WhatTheFishApp({super.key});

@override

Widget build(BuildContext context) {

return MultiProvider(

providers: [

ChangeNotifierProvider(create: (_) => FishProvider()),

],

child: MaterialApp(

title: 'What the Fish',

theme: AppTheme.oceanTheme,

darkTheme: AppTheme.darkOceanTheme,

themeMode: ThemeMode.system,

home: const SplashScreen(),

debugShowCheckedModeBanner: false,

),

);

}

}

```

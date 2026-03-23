import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final storage = StorageService();
  await storage.init();

  runApp(HangyeolHangulApp(storage: storage));
}

class HangyeolHangulApp extends StatelessWidget {
  final StorageService storage;

  const HangyeolHangulApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '한결이의 한글 놀이터',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: HomeScreen(storage: storage),
    );
  }
}

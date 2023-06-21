import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/firebase_options.dart';
import 'package:smooth_study/screens/audio_page.dart';
import 'package:smooth_study/screens/dashboard.dart';
import 'package:smooth_study/utils/storage_manager.dart';
import 'package:smooth_study/utils/theme_provider.dart';
import 'package:smooth_study/utils/material_box.dart';
import 'package:smooth_study/utils/recently_viewed_box.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await MaterialBox.initialize();
  await RecentViewedBox.initialize();
  await StorageManager.initialize();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, controller, child) {
        return MaterialApp(
          theme: controller.getTheme(),
          debugShowCheckedModeBanner: false,
          home: const AudioPage(audioTitle: 'CSC 101',),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hindlish/purchase_api.dart';
import 'package:hindlish/vm/chat_provider.dart';
import 'package:hindlish/vm/screenshot_provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'views/splash.dart';
import 'vm/chatListVm.dart';
import 'vm/uploadedImgsVM.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  await Hive.openBox('listOfChat');
  await Hive.openBox('listOfScreenShots');
  await Hive.openBox('additional_info');
  await Hive.openBox('bottom_sheet_screenShots');
  await Hive.openBox('aiChats');
  await Hive.openBox('Stngs');
  await PurchaseAPI.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => ScreenShotProvider()),
        ChangeNotifierProvider(create: (context) => UploadImgsVMC()),
        ChangeNotifierProvider(create: (context) => ChatsListVmC()),
      ],
      child: MaterialApp(
          title: 'HindLish',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ThemeColor.cyan),
              useMaterial3: true,
              scaffoldBackgroundColor: ThemeColor.cyan,
              appBarTheme: const AppBarTheme(backgroundColor: ThemeColor.cyan)),
          debugShowCheckedModeBanner: false,
          home: const SplashPage()
          // home: const HomePage(),
          ),
    );
  }
}

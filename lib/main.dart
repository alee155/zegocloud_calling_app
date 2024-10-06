import 'package:call/firebase_options.dart';
import 'package:call/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((_) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const LoginScreen(),
    );
  }
}

// import 'package:call/callinvitescree.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// class WelcomeScreen extends StatefulWidget {
//   final GlobalKey<NavigatorState> navigatorKey;

//   const WelcomeScreen({super.key, required this.navigatorKey});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   @override
//   final callId = TextEditingController();
//   final userName = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Users'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextFormField(
//             controller: callId,
//             decoration: const InputDecoration(hintText: "Enter you call id"),
//           ),
//           TextFormField(
//             controller: userName,
//             decoration: const InputDecoration(hintText: "Enter your User name"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const CallinviteScreen()),
//               );
//               ZegoUIKitPrebuiltCallInvitationService().init(
//                 appID: 1922490476,
//                 appSign:
//                     '30e243ca38e2a5ac77207fb9c619ff4ef353b69cf613915c9a1cc63799b5b7ab',
//                 userID: callId.text.trim(),
//                 userName: userName.text.trim(),
//                 plugins: [ZegoUIKitSignalingPlugin()],
//               );
//             },
//             child: const Text('invite'),
//           )
//         ],
//       ),
//     );
//   }
// }

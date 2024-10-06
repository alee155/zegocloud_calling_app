import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallinviteScreen extends StatefulWidget {
  final String currentUserId;
  final String userName;
  final String inviteeUserId; 

  const CallinviteScreen({
    super.key,
    required this.currentUserId,
    required this.userName,
    required this.inviteeUserId,
  });

  @override
  State<CallinviteScreen> createState() => _CallinviteScreenState();
}

class _CallinviteScreenState extends State<CallinviteScreen> {
  @override
  void initState() {
    super.initState();

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1922490476,
      appSign:
          '30e243ca38e2a5ac77207fb9c619ff4ef353b69cf613915c9a1cc63799b5b7ab',
      userID: widget.currentUserId, 
      userName: widget.userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ZegoSendCallInvitationButton(
          isVideoCall: true,
          resourceID: "zegouikit_call",
          invitees: [
            ZegoUIKitUser(
              id: widget.inviteeUserId,
              name: "Invitee", 
            ),
          ],
        ),
      ),
    );
  }
}

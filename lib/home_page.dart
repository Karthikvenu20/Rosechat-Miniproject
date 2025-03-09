import 'package:flutter/material.dart';
import 'package:democalls/constants/constants.dart';
import 'package:democalls/services/login_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController inviteeUserIDTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logOut();
              if (mounted) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, PageRouteName.login);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged in as: ${Constants.currentUser.name}',
              style: Constants.textStyle,
            ),
            const SizedBox(height: 20),
            inviteeInputRow(),
          ],
        ),
      ),
    );
  }

  Widget inviteeInputRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: inviteeUserIDTextCtrl,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Invitee ID',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sendCallButton(isVideoCall: false),
            const SizedBox(width: 10),
            sendCallButton(isVideoCall: true),
          ],
        ),
      ],
    );
  }

  Widget sendCallButton({required bool isVideoCall}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUserIDTextCtrl,
      builder: (context, value, _) {
        final invitees =
            getInvitesFromTextCtrl(inviteeUserIDTextCtrl.text.trim());
        return ZegoSendCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
          resourceID: 'zego_data',
          iconSize: const Size(40, 40),
          buttonSize: const Size(50, 50),
        );
      },
    );
  }
}

List<ZegoUIKitUser> getInvitesFromTextCtrl(String text) {
  final invitees = <ZegoUIKitUser>[];
  final inviteeIDs = text.split(',');
  for (var id in inviteeIDs) {
    final trimmedID = id.trim();
    if (trimmedID.isNotEmpty) {
      invitees.add(ZegoUIKitUser(id: trimmedID, name: 'user_$trimmedID'));
    }
  }
  return invitees;
}

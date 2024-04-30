import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

String userID = Random().nextInt(10000).toString();

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(arguments);
    String? currentUid = arguments!["currentUid"];
    String? otherUid = arguments!["otherUid"];
    String name = arguments!["nameCurrent"];

    List<String?> ids = [currentUid, otherUid];
    ids.sort();
    String callId = ids.join("_");
    return ZegoUIKitPrebuiltCall(
        appID: 1516252591,
        appSign:
            "a493ad68d54dab428ef205bfb4ea2518c4424e109d54820c0d559d1d0e14cc55",
        callID: callId,
        userID: "user_$userID",
        userName: name,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}

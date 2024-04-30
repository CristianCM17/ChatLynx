import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class CallScreen extends StatefulWidget {
 // final Map<String,dynamic>? arguments;

  const CallScreen({super.key, });

  

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  

  
  
  @override
  Widget build(BuildContext context) {
    //String? currentUid = widget.arguments!["currentUid"];
  // String? otherUid = widget.arguments!["otherUid"];

   //List<String?> ids= [currentUid, otherUid];
  // ids.sort();
   //String callId=ids.join("_");
    return ZegoUIKitPrebuiltCall(
       appID: 1516252591,
       appSign: "a493ad68d54dab428ef205bfb4ea2518c4424e109d54820c0d559d1d0e14cc55", 
       callID: "123", 
       userID: "Cristian123", 
       userName: "Cristian", 
       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
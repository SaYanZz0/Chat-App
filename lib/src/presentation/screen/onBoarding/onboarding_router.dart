import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IOnboardingRouter {
  void onSessionSuccess(BuildContext context, User user);
}

class OnBoardingRouter implements IOnboardingRouter {
  final Function(User user) onSessionConnected;
  OnBoardingRouter(this.onSessionConnected);
  @override
  void onSessionSuccess(BuildContext context, User user) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => onSessionConnected(user)),
        (Route<dynamic> route) => false);
  }
}

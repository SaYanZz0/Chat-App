import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter_newapp/src/blocs/onBoarding/onboarding_state.dart';
import 'package:flutter_newapp/src/data/Services/image_uploader.dart';
import 'package:flutter_newapp/src/data/Services/local_cache.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final IUserService userService;
  final ILocalCache localCache;
  final ImageUploader imageUploader;
  OnBoardingCubit(this.userService, this.localCache, this.imageUploader)
      : super(OnBoardingInitial());

  Future<void> connect(String name, File profilImage) async {
    emit(Loading());
    final url = await imageUploader.uploadImage(profilImage);
    final user = User(
        username: name, photoUrl: url, active: true, lastSeen: DateTime.now());
    final createdUser = await userService.connect(user);
    final userJson = {
      'username': createdUser.username,
      'photoUrl': createdUser.photoUrl,
      'active': createdUser.active,
      'lastSeen': createdUser.lastSeen
    };
    await localCache.save('USER', userJson);
    emit(OnboardingSuccess(user));
  }
}

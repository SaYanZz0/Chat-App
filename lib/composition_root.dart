import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_newapp/src/blocs/onBoarding/onboarding_cubit.dart';
import 'package:flutter_newapp/src/blocs/onBoarding/prfil_image_cubit.dart';
import 'package:flutter_newapp/src/data/Services/image_uploader.dart';
import 'package:flutter_newapp/src/data/Services/local_cache.dart';
import 'package:flutter_newapp/src/presentation/screen/onBoarding/onboarding.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompositionRoot {
  static late SharedPreferences _sharedPreferences;
  static late RethinkDb _r;
  static late Connection _connection;
  static late IUserService _userService;
  static late ILocalCache _localCache;
  static late ImageUploader imageUploader;

  static configure() async {
    _r = RethinkDb();
    _connection = await _r.connect(host: "172.31.192.1", port: 28015);
    _userService = UserService(_r, _connection);
    _localCache = LocalCache(_sharedPreferences);
  }

  static Widget composeOnboardingUi() {
    ImageUploader imageUploader = ImageUploader('http://localhost:3000/upload');
    OnBoardingCubit onboardingCubit =
        OnBoardingCubit(_userService, _localCache, imageUploader);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onboardingCubit),
      BlocProvider(create: (BuildContext context) => ProfileImageCubit())
    ], child: OnBoardingScreen());
  }
}

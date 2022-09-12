import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/social_login/social_login_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  token = FirebaseMessaging.instance.getToken();
  Widget? startWidget;
  if (uId != null) {
    startWidget = const SocialLayout();
  } else {
    startWidget = SocialLoginScreen();
  }
  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.startWidget,
  }) : super(key: key);
  final Widget? startWidget;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialCubit()
        ..getPosts()
        ..getUserData(),
      child: MaterialApp(
        title: 'Social App',
        theme: lightTheme,
        home: startWidget,
      ),
    );
  }
}

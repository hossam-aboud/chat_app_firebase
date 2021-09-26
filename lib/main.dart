import 'package:bloc/bloc.dart';
import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/layouts/social_layout.dart';
import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:chat_app/shared/networks/local/cache_helper.dart';
import 'package:chat_app/shared/obs_sever.dart';
import 'package:chat_app/shared/styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await CacheHelper.init();
  String? token = await FirebaseMessaging.instance.getToken();

  print(token);

  // ForGround Messages
  FirebaseMessaging.onMessage.listen((event) {
    // on message notifications open app
    print(event.data.toString());
    // showToast(message: 'On Message', stateType: StateType.success);
    showToast(message: 'Welcome', stateType: StateType.success);
  });

  // BackGround Messages
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    // on message notifications open app  (backGround)

    print(event.data.toString());
    //  showToast(message: 'On Message Opened App', stateType: StateType.success);
    showToast(message: 'Welcome', stateType: StateType.success);
  });

  // BackGround Messages
  FirebaseMessaging.onBackgroundMessage((message) async {
    // on message is closed application بشكل نهائي
    print(message.data.toString());
    //showToast(message: 'On BackGround Message', stateType: StateType.success);
    showToast(message: 'Welcome', stateType: StateType.success);
  });
  userID = CacheHelper.getData(key: 'uId');

  runApp(
    const MyApp(),
  );
}

// alt + -
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return SocialCubit()
              ..getUserData()
              ..getPostsStreamBuilder();
          },
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (BuildContext context, SocialStates state) {},
        builder: (BuildContext context, SocialStates state) {
          return MaterialApp(
            locale: const Locale(
              'en',
            ),
            debugShowCheckedModeBanner: false,
            title: 'Chat Firebase',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, snapshots) {
                if (snapshots.hasData) {
                  return const SocialLayout();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

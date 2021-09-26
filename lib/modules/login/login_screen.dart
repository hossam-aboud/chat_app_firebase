import 'package:chat_app/layouts/social_layout.dart';
import 'package:chat_app/modules/login/cubit/cubit.dart';
import 'package:chat_app/modules/login/cubit/states.dart';
import 'package:chat_app/modules/sign_up/sign_up_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:chat_app/shared/networks/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (BuildContext context, LoginStates state) {
        if (state is LoginErrorUserState) {
          showToast(
              message: state.errorMsg.toString(), stateType: StateType.error);
        }
        if (state is LoginSuccessUserState) {
          CacheHelper.saveData(key: 'uId', value: state.uID).then((value) {
            if (value) {
              showToast(
                message: 'Successfully Register',
                stateType: StateType.success,
              );
              removeUntilScreen(context: context, screen: const SocialLayout());
            } else {
              showToast(
                message: 'Error Register User ID',
                stateType: StateType.error,
              );
            }
          });
        }
      }, builder: (BuildContext context, LoginStates state) {
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formState,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Login now to communicate with friends ',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.grey, fontSize: 16.0),
                      ),
                      const SizedBox(height: 30.0),
                      DefaultTextField(
                        key: const Key('email'),
                        label: 'Email Address',
                        controller: emailController,
                        typeText: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The Email Field Must be not Empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      DefaultTextField(
                        key: const Key('password'),
                        label: 'Password',
                        controller: passwordController,
                        secureText: cubit.isSecure,
                        onEditingComplete: () {
                          if (formState.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            cubit.loginUser(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          }
                        },
                        typeText: TextInputType.visiblePassword,
                        prefixIcon: Icons.security_outlined,
                        suffixIcon: cubit.secureVisibility,
                        suffixOnPressed: () {
                          cubit.checkVisibility();
                        },
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The Password Field Must be not Empty';
                          } else if (value.length < 8) {
                            return 'Weak password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      if (state is LoginLoadingUserState)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (state is! LoginLoadingUserState)
                        DefaultElevatedButton(
                          labelText: 'login',
                          onPressed: () {
                            // if (formState.currentState!.validate()) {
                            //   FocusScope.of(context).unfocus();
                            //   cubit.loginUser(
                            //     email: emailController.text.trim(),
                            //     password: passwordController.text.trim(),
                            //   );
                            // }
                            // add data to firestore database
                            FirebaseFirestore.instance.collection('type').add(
                              {
                                'gender': 'Hello World',
                              },
                            );
                            // get data (real time from data base)
                            FirebaseFirestore.instance
                                .collection('type')
                                .snapshots()
                                .listen((event) {
                              for (var element in event.docs) {
                                print(element['gender']);
                              }
                            }).onError(
                              (error) {
                                print(
                                  error.toString(),
                                );
                              },
                            );
                          },
                        ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                          ),
                          TextButton(
                            onPressed: () {
                              removeUntilScreen(
                                context: context,
                                screen: const SignUpScreen(),
                              );
                            },
                            child: const Text(
                              'REGISTER',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

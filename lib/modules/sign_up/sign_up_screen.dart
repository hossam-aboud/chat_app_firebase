import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/layouts/social_layout.dart';
import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/modules/sign_up/cubit/cubit.dart';
import 'package:chat_app/modules/sign_up/cubit/states.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:chat_app/shared/networks/local/cache_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return RegisterCubit();
      },
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (BuildContext context, RegisterStates state) {
        // if (state is RegisterErrorUserState) {
        //   print(state.errorMsg);
        //   if (state.errorMsg ==
        //       '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        //     showToast(
        //       message: 'the email already exists !',
        //       stateType: StateType.error,
        //     );
        //   }
        // }
        if (state is RegisterSuccessUserInfoState) {
          CacheHelper.saveData(key: 'uId', value: state.userModel.uId)
              .then((value) {
            if (value) {
              userID = state.userModel.uId;
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
      }, builder: (BuildContext context, RegisterStates state) {
        RegisterCubit cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Form(
                  key: formState,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'REGISTER',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Register now to communicate with friends ',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.grey, fontSize: 16.0),
                      ),
                      const SizedBox(height: 30.0),
                      DefaultTextField(
                        key: const Key('username'),
                        label: 'Username',
                        controller: usernameController,
                        typeText: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The username Field Must be not Empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      DefaultTextField(
                        key: const Key('email'),
                        label: 'Email Address',
                        controller: emailController,
                        typeText: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The Email Field Must be not Empty';
                          } else if (!EmailValidator.validate(value)) {
                            return 'The Email Syntax Error';
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
                        suffixIcon: cubit.secureVisibility,
                        suffixOnPressed: () {
                          cubit.checkVisibility();
                        },
                        typeText: TextInputType.visiblePassword,
                        prefixIcon: Icons.security_outlined,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The Password Field Must be not Empty';
                          } else if (value.length < 8) {
                            return 'Weak password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      DefaultTextField(
                        key: const Key('phoneNumber'),
                        label: 'Phone',
                        controller: phoneController,
                        typeText: TextInputType.phone,
                        onEditingComplete: () {
                          if (formState.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            cubit.registerToFirebaseAuth(
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              phone: phoneController.text.trim(),
                            );
                          }
                        },
                        prefixIcon: Icons.phone_android_outlined,
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'The Phone Field Must be not Empty';
                          } else if (value.isNotEmpty) {
                            bool checkValidator = cubit.checkPhoneNumber(value);
                            if (!checkValidator) {
                              return "The Phone Field Must be 10 number and start with \"059\" ";
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      if (state is RegisterLoadingUserState)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (state is! RegisterLoadingUserState)
                        DefaultElevatedButton(
                          labelText: 'register',
                          onPressed: () async {
                            if (!formState.currentState!.validate()) {
                              Flushbar(
                                messageText: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    const Text(
                                      'please fill the inputs ...!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                  bottom: 5.0,
                                  top: 5.0,
                                ),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.yellow,
                                showProgressIndicator: false,
                                flushbarPosition: FlushbarPosition.TOP,
                                onTap: (value) {},
                              ).show(context);
                            } else {
                              cubit.registerToFirebaseAuth(
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                phone: phoneController.text.trim(),
                              );
                            }
                          },
                        ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                          ),
                          TextButton(
                            onPressed: () {
                              removeUntilScreen(
                                context: context,
                                screen: const LoginScreen(),
                              );
                            },
                            child: const Text(
                              'SIGNIN',
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

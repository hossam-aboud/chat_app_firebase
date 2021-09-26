import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/layouts/social_layout.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostScreen extends StatefulWidget {
  final UserModel? dateUser;
  NewPostScreen({
    this.dateUser,
  });
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var textController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getUserData();

        return BlocProvider(
          create: (BuildContext context) {
            return SocialCubit.get(context)..getPostsStreamBuilder();
          },
          child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (BuildContext context, SocialStates state) {
              if (state is SocialCreatePostSuccessState) {
                textController.clear();
                SocialCubit.get(context).removePostImage();
                showToast(
                  message: 'Successfully Created post',
                  stateType: StateType.success,
                );
              }
            },
            builder: (BuildContext context, SocialStates state) {
              // var dateUser = SocialCubit.get(context).userDataModel;
              var cubit = SocialCubit.get(context);

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Create Post'),
                  leading: IconButton(
                    onPressed: () {
                      removeUntilScreen(
                        context: context,
                        screen: const SocialLayout(),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  actions: [
                    DefaultTextButton(
                      text: 'post',
                      isEnabled:
                          state is SocialCreatePostLoadingState ? false : true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        var now = DateTime.now();
                        if (!cubit.postImage!.isAbsolute) {
                          cubit.createPost(
                            dateTime: now.toString(),
                            text: textController.text.trim(),
                          );
                        } else {
                          cubit.uploadPostImage(
                            dateTime: now.toString(),
                            text: textController.text.trim(),
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            if (state is SocialCreatePostLoadingState)
                              const LinearProgressIndicator(),
                            if (state is SocialCreatePostLoadingState)
                              const SizedBox(
                                height: 10.0,
                              ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                    widget.dateUser!.image,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.dateUser!.username,
                                          style: const TextStyle(
                                            height: 1.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                              ],
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: textController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintText: 'What is your mind ...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            if (cubit.postImage!.isAbsolute)
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: 200.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0),
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(cubit.postImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cubit.removePostImage();
                                    },
                                    icon: const CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.close,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              width: 20.0,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                cubit.getPostImage();
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate_outlined,
                              ),
                              label: const Text(
                                'add photo',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                '# tags',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

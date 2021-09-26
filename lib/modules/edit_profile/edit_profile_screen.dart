import 'dart:io';

import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/layouts/social_layout.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userData;
  EditProfileScreen({
    required this.userData,
  });
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;

  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    bioController = TextEditingController();
    print('"EditProfileScreen" ---------> initialState');
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    print('"EditProfileScreen" ---------> disposed');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUserData();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (BuildContext context, SocialStates state) {},
          builder: (BuildContext context, SocialStates state) {
            var cubit = SocialCubit.get(context);
            // var userData = SocialCubit.get(context).userDataModel;
            nameController.text = widget.userData.username;
            phoneController.text = widget.userData.phone;
            bioController.text = widget.userData.bio;
            File? profileImage = SocialCubit.get(context).profileImage;
            File? coverImage = SocialCubit.get(context).coverImage;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
                leading: IconButton(
                  onPressed: () {
                    navigateTo(
                      context: context,
                      screen: const SocialLayout(),
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                  DefaultTextButton(
                    text: 'update',
                    isEnabled: true,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      cubit.updateUser(
                        username: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        bio: bioController.text.trim(),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state is SocialUserUpdateLoadingState)
                        const LinearProgressIndicator(),
                      if (state is SocialUserUpdateLoadingState)
                        const SizedBox(
                          height: 10.0,
                        ),
                      SizedBox(
                        height: 190.0,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(
                                          4.0,
                                        ),
                                        topRight: Radius.circular(
                                          4.0,
                                        ),
                                      ),
                                      image: DecorationImage(
                                        image: coverImage!.isAbsolute
                                            ? FileImage(coverImage)
                                            : NetworkImage(
                                                widget.userData.coverImage,
                                              ) as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cubit.getCoverImage();
                                    },
                                    icon: const CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.camera_outlined,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: profileImage!.isAbsolute
                                        ? FileImage(profileImage)
                                        : NetworkImage(
                                            widget.userData.image,
                                          ) as ImageProvider,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.camera_outlined,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (SocialCubit.get(context).profileImage!.isAbsolute ||
                          SocialCubit.get(context).coverImage!.isAbsolute)
                        Row(
                          children: [
                            if (SocialCubit.get(context)
                                .profileImage!
                                .isAbsolute)
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: DefaultElevatedButton(
                                        labelText: 'upload profile',
                                        onPressed: () {
                                          cubit.uploadProfileImage(
                                            username:
                                                nameController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            bio: bioController.text.trim(),
                                          );
                                        },
                                      ),
                                    ),
                                    if (state is SocialUserUpdateLoadingState)
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    if (state is SocialUserUpdateLoadingState)
                                      const LinearProgressIndicator(),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            if (SocialCubit.get(context).coverImage!.isAbsolute)
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: DefaultElevatedButton(
                                        labelText: 'upload cover',
                                        onPressed: () {
                                          cubit.uploadCoverImage(
                                            username:
                                                nameController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            bio: bioController.text.trim(),
                                          );
                                        },
                                      ),
                                    ),
                                    if (state is SocialUserUpdateLoadingState)
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    if (state is SocialUserUpdateLoadingState)
                                      const LinearProgressIndicator(),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (SocialCubit.get(context).profileImage!.isAbsolute ||
                          SocialCubit.get(context).coverImage!.isAbsolute)
                        const SizedBox(
                          height: 20.0,
                        ),
                      DefaultTextField(
                        key: const ValueKey('update_name'),
                        label: 'Name',
                        controller: nameController,
                        typeText: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The username Field Must be not Empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      DefaultTextField(
                        key: const ValueKey('bio_user'),
                        label: 'Bio',
                        controller: bioController,
                        typeText: TextInputType.text,
                        prefixIcon: Icons.info_outline,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The Bio Field Must be not Empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      DefaultTextField(
                        key: const ValueKey('phone_user'),
                        label: 'Phone',
                        controller: phoneController,
                        typeText: TextInputType.phone,
                        prefixIcon: Icons.phone_android_outlined,
                        validator: (String? value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'The Phone Field Must be not Empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

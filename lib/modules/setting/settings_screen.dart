import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (BuildContext context, SocialStates state) {},
        builder: (BuildContext context, SocialStates state) {
          var userModel = SocialCubit.get(context).userDataModel;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 190.0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
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
                                image: NetworkImage(
                                  userModel!.coverImage,
                                ),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      CircleAvatar(
                        radius: 64.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(userModel.image),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  userModel.username,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
                Text(
                  userModel.bio,
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '100',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    'Posts',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '265',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    'Photos',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '10k',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    'Followers',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '64',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    'Followings',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          'Add Photos',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        removeUntilScreen(
                          context: context,
                          screen: EditProfileScreen(
                            userData: userModel,
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

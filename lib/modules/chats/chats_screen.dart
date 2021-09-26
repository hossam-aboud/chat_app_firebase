import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/modules/chat_detalis/chat_detalis_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).startTimerChatsScreen();
        return BlocProvider(
          create: (BuildContext context) {
            return SocialCubit()..getAllUsers();
          },
          child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (BuildContext context, SocialStates state) {},
            builder: (BuildContext context, SocialStates state) {
              var allUsers = SocialCubit.get(context).users;
              var seconds2 = SocialCubit.get(context).seconds2;

              return allUsers.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          buildChatItem(context, allUsers[index]),
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 1.0,
                          width: double.infinity,
                          color: Colors.grey,
                        );
                      },
                      itemCount: allUsers.length,
                    )
                  : state is! SocialTimerCancelState
                      ? _buildShimmerChatUsers()
                      : const Center(
                          child: Text(
                            'There is no users yet !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerChatUsers() {
    return Shimmer.fromColors(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 25.0,
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              'waiting ...',
              style: TextStyle(
                height: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    );
  }

  Widget buildChatItem(BuildContext context, UserModel model) => InkWell(
        onTap: () {
          navigateTo(
            context: context,
            screen: ChatDetailsScreen(
              model,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  model.image,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                model.username,
                style: const TextStyle(
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}

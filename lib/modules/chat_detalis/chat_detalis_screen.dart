import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:chat_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  ChatDetailsScreen(this.userModel);
  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (BuildContext context, SocialStates state) {
            if (state is SocialGetMessageSuccessState) {
              textController.clear();
              FocusScope.of(context).unfocus();
            }
          },
          builder: (BuildContext context, SocialStates state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        userModel.image,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userModel.username,
                    ),
                  ],
                ),
              ),
              //   SocialCubit.get(context).messages.isNotEmpty
              //       ?
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: ListView.separated(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];
                            if (userID == message.senderId) {
                              return buildMyMessage(
                                  SocialCubit.get(context).messages[index]);
                            }
                            return buildMessage(
                                SocialCubit.get(context).messages[index]);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 15.0,
                            );
                          },
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: TextFormField(
                                controller: textController,
                                onChanged: (String value) {
                                  SocialCubit.get(context)
                                      .checkEnabledButtonChat(value);
                                },
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here ...',
                                    hintStyle: TextStyle()),
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            color: SocialCubit.get(context).isChatButtonEnables
                                ? defaultColor
                                : Colors.grey[300],
                            child: MaterialButton(
                              onPressed:
                                  SocialCubit.get(context).isChatButtonEnables
                                      ? () {
                                          SocialCubit.get(context).sendMessage(
                                            receiverId: userModel.uId,
                                            dateTime: DateTime.now().toString(),
                                            text: textController.text.trim(),
                                          );
                                        }
                                      : null,
                              child: const Icon(
                                Icons.send_outlined,
                                size: 16.0,
                                color: Colors.white,
                              ),
                              minWidth: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
            ),
          ),
          child: Text(
            model.text,
          ),
        ),
      );
  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
            ),
          ),
          child: Text(
            model.text,
          ),
        ),
      );
}

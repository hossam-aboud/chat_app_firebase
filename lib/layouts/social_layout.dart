import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/modules/new_post/new_post_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SocialCubit()..getUserData();
      },
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (BuildContext context, SocialStates state) {
          if (state is SocialNewPostState) {
            navigateTo(
              context: context,
              screen: NewPostScreen(
                dateUser: SocialCubit.get(context).userDataModel,
              ),
            );
          }
        },
        builder: (BuildContext context, SocialStates state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${cubit.screens[cubit.currentIndex]['title']}',
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_outlined,
                  ),
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex]['screen'] as Widget,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.changeBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.post_add_outlined),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.location_on_outlined,
                  ),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

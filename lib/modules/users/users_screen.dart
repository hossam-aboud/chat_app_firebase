import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).startTimerUsersScreen();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (BuildContext context, SocialStates state) {},
          builder: (BuildContext context, SocialStates state) {
            var cubit = SocialCubit.get(context);
            var second = SocialCubit.get(context).seconds;
            return cubit.userDataModel != null &&
                    cubit.allUsersRegister.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return getAllUsersRegisterFromApplication(
                        cubit.allUsersRegister[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.grey,
                      );
                    },
                    itemCount: cubit.allUsersRegister.length,
                  )
                : second != 5
                    ? _buildShimmerUsers()
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
        );
      },
    );
  }

  Widget _buildShimmerUsers() {
    return Shimmer.fromColors(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 25.0,
            ),
            const SizedBox(
              width: 15.0,
            ),
            const Text(
              'waiting ...',
              style: TextStyle(
                height: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'waiting ...',
              ),
            ),
          ],
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    );
  }

  Widget getAllUsersRegisterFromApplication(UserModel model) {
    return InkWell(
      onTap: () {},
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
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'OPEN',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

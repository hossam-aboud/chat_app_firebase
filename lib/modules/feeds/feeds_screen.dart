import 'package:chat_app/layouts/cubit/cubit.dart';
import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/model/post_model.dart';
import 'package:chat_app/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SocialCubit()
          ..getUserData()
          ..getPostsStreamBuilder();
      },
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (BuildContext context, SocialStates state) {},
        builder: (BuildContext context, SocialStates state) {
          var posts = SocialCubit.get(context).posts;
          return posts.isNotEmpty &&
                  SocialCubit.get(context).userDataModel != null
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.all(
                          8.0,
                        ),
                        elevation: 5.0,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const Image(
                              image: NetworkImage(
                                'https://image.freepik.com/free-photo/man-filming-with-professional-camera_23-2149066324.jpg',
                              ),
                              fit: BoxFit.cover,
                              height: 200.0,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'communicate with friends',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return buildPostItem(
                            SocialCubit.get(context).posts[index],
                            context,
                            SocialCubit.get(context).postsId[index],
                            index,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10.0);
                        },
                        itemCount: SocialCubit.get(context).posts.length,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    'There is No Posts Yet !',
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
  }

  Widget buildPostItem(
      PostModel model, BuildContext context, String postId, int index) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                    SocialCubit.get(context).userDataModel!.image,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            SocialCubit.get(context).userDataModel!.username,
                            style: const TextStyle(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 16.0,
                            color: defaultColor,
                          ),
                        ],
                      ),
                      Text(
                        model.dateTime.toString(),
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                top: 5.0,
              ),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            Text(
              model.text,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10.0,
            //   ),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: Wrap(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsetsDirectional.only(
            //             end: 6.0,
            //           ),
            //           child: SizedBox(
            //             height: 20.0,
            //             child: MaterialButton(
            //               onPressed: () {},
            //               minWidth: 1.0,
            //               padding: EdgeInsets.zero,
            //               child: Text(
            //                 '#software',
            //                 style:
            //                     Theme.of(context).textTheme.caption!.copyWith(
            //                           color: defaultColor,
            //                         ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            if (model.postImage != '')
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        4.0,
                      ),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        model.postImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite_outline,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            // Text(
                            //   '${SocialCubit.get(context).likes[index]}',
                            //   style: Theme.of(context).textTheme.caption,
                            // ),
                            Text(
                              '1',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.chat_outlined,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '0 commit',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                            SocialCubit.get(context).userDataModel!.image,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'write a commit....',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_outline,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: () {
                    //  SocialCubit.get(context).likePost(postId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerFeedsLoading extends StatelessWidget {
  const ShimmerFeedsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.all(
                8.0,
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 200.0,
                    width: double.infinity,
                  ),
                  const Image(
                    image: NetworkImage(
                      'https://image.freepik.com/free-photo/man-filming-with-professional-camera_23-2149066324.jpg',
                    ),
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'communicate with friends',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.all(
                8.0,
              ),
              elevation: 5.0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const Image(
                    image: NetworkImage(
                      'https://image.freepik.com/free-photo/man-filming-with-professional-camera_23-2149066324.jpg',
                    ),
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'communicate with friends',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

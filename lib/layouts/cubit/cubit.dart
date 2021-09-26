import 'dart:async';
import 'dart:io';

import 'package:chat_app/layouts/cubit/states.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/post_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/modules/chats/chats_screen.dart';
import 'package:chat_app/modules/feeds/feeds_screen.dart';
import 'package:chat_app/modules/new_post/new_post_screen.dart';
import 'package:chat_app/modules/setting/settings_screen.dart';
import 'package:chat_app/modules/users/users_screen.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(BuildContext context) => BlocProvider.of(context);

  late UserModel? userDataModel;
  void getUserData() {
    print('----------------> (SocialCubit) -------> $userID');

    emit(SocialGetUserLoadingDataState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value) {
      userDataModel = UserModel.fromJSON(value.data()!);
      print(
          '""updateUser Method"" --------> INVOKED ====? ${userDataModel!.coverImage}');
      print(
          '----------------> (SocialCubit) -------> ${userDataModel!.username}');
      emit(SocialGetUserSuccessDataState());
    }).catchError((error) {
      print('----------------> (SocialCubit) -------> ERROR NULL DATA');

      emit(SocialGetUserErrorDataState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Map<String, Object>> screens = [
    {
      'title': 'Home',
      'screen': const FeedScreen(),
    },
    {
      'title': 'Chats',
      'screen': const ChatsScreen(),
    },
    {
      'title': 'New Post',
      'screen': NewPostScreen(),
    },
    {
      'title': 'Users',
      'screen': const UsersScreen(),
    },
    {
      'title': 'Settings',
      'screen': const SettingsScreen(),
    },
  ];

  void changeBottomNav(int index) {
    if (index == 0) {
      getPostsStreamBuilder();
    }
    if (index == 1) {
      getAllUsers();
    }
    if (index == 3) {
      getAllUsersRegister();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  List allUsersRegister = <UserModel>[];
  void getAllUsersRegister() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      allUsersRegister = [];
      for (var element in value.docs) {
        if (element.data()['uId'] != userID) {
          allUsersRegister.add(
            UserModel.fromJSON(
              element.data(),
            ),
          );
        }
      }
      emit(SocialGetAllUsersRegisterSuccessState());
    }).catchError(
      (error) {
        emit(SocialGetAllUsersRegisterErrorState());
      },
    );
  }

  late Timer timer;
  int seconds = 1;
  void startTimerUsersScreen() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (seconds != 5) {
          seconds = seconds + 1;
          print(seconds);
          emit(SocialTimerStarterState());
        } else {
          timer.cancel();
          emit(SocialTimerCancelState());
        }
      },
    );
  }

  int seconds2 = 1;
  void startTimerChatsScreen() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (seconds2 != 5) {
          seconds2 = seconds2 + 1;
          print(seconds2);
          emit(SocialTimerStarterState());
        } else {
          timer.cancel();
          emit(SocialTimerCancelState());
        }
      },
    );
  }

  late File? profileImage = File('sdsd');
  final picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      emit(SocialProfileImagePickedErrorState());
      print('There is No Image Selected');
    }
  }

  late File? coverImage = File('sdsd');

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      emit(SocialCoverImagePickedErrorState());
      print('There is No Image Selected');
    }
  }

  // String profileImageUrl = '';
  void uploadProfileImage({
    required String username,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/${Uri.file(
            profileImage!.path,
          ).pathSegments.last}',
        )
        .putFile(
          profileImage!,
        )
        .then(
      (TaskSnapshot value) {
        value.ref.getDownloadURL().then(
          (value) {
            //   profileImageUrl = value;
            // emit(SocialUploadProfileImageSuccessState());
            updateUser(
              username: username,
              phone: phone,
              bio: bio,
              profile: value,
            );
          },
        ).catchError(
          (error) {
            emit(SocialUploadProfileImageErrorState());
          },
        );
      },
    ).catchError(
      (error) {
        emit(SocialUploadProfileImageErrorState());
      },
    );
  }

  // String coverImageUrl = '';
  void uploadCoverImage({
    required String username,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/${Uri.file(
            coverImage!.path,
          ).pathSegments.last}',
        )
        .putFile(
          coverImage!,
        )
        .then(
      (TaskSnapshot value) {
        value.ref.getDownloadURL().then(
          (value) {
            // coverImageUrl = value;
            //  emit(SocialUploadCoverImageSuccessState());
            updateUser(
              username: username,
              phone: phone,
              bio: bio,
              cover: value,
            );
          },
        ).catchError(
          (error) {
            emit(SocialUploadCoverImageErrorState());
          },
        );
      },
    ).catchError(
      (error) {
        emit(SocialUploadCoverImageErrorState());
      },
    );
  }

  // void updateUserImages({
  //   required String username,
  //   required String phone,
  //   required String bio,
  // }) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (coverImage!.isAbsolute && profileImage!.isAbsolute) {
  //     uploadCoverImage();
  //     uploadProfileImage();
  //   } else if (coverImage!.isAbsolute) {
  //     uploadCoverImage();
  //   } else if (profileImage!.isAbsolute) {
  //     uploadProfileImage();
  //   } else {
  //     updateUser(username: username, phone: phone, bio: bio);
  //   }
  // }

  void updateUser({
    required String username,
    required String phone,
    required String bio,
    String? cover,
    String? profile,
  }) {
    print('else -------------> UPDATE');
    UserModel userModel = UserModel(
      uId: userDataModel!.uId,
      username: username,
      email: userDataModel!.email,
      phone: phone,
      image: profile ?? userDataModel!.image,
      coverImage: cover ?? userDataModel!.coverImage,
      bio: bio,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userDataModel!.uId)
        .update(
          userModel.toMap(),
        )
        .then(
      (value) {
        print('""updateUser Method"" --------> INVOKED ');
        getUserData();
      },
    ).catchError(
      (error) {
        emit(SocialUserUpdateErrorState());
      },
    );
  }

  late File? postImage = File('sdsd');

  void removePostImage() {
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .snapshots()
    //     .listen((event) {});
    postImage = File('sdsd');

    emit(SocialRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      emit(SocialPostImagePickedErrorState());
      print('There is No Image Selected');
    }
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'posts/${Uri.file(
            postImage!.path,
          ).pathSegments.last}',
        )
        .putFile(
          postImage!,
        )
        .then(
      (TaskSnapshot value) {
        value.ref.getDownloadURL().then(
          (value) {
            createPost(
              dateTime: dateTime,
              text: text,
              postImage: value,
            );
          },
        ).catchError(
          (error) {
            emit(SocialCreatePostErrorState());
          },
        );
      },
    ).catchError(
      (error) {
        emit(SocialCreatePostErrorState());
      },
    );
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    print('else -------------> UPDATE');
    PostModel postModel = PostModel(
      uId: userDataModel!.uId,
      username: userDataModel!.username,
      image: userDataModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(
          postModel.toMap(),
        )
        .then(
      (value) {
        emit(SocialCreatePostSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialCreatePostErrorState());
      },
    );
  }

  List<PostModel> posts = <PostModel>[];

  List<String> postsId = <String>[];

  List<int> likes = <int>[];

  void getPostsStreamBuilder() {
    emit(SocialGetPostLoadingDataState());
    FirebaseFirestore.instance.collection('posts').snapshots().listen(
      (event) {
        for (var element in event.docs) {
          posts.add(
            PostModel.fromJSON(
              element.data(),
            ),
          );
          postsId.add(
            element.id.toString(),
          );
        }
        emit(SocialGetPostSuccessDataState());
      },
    ).onError(
      (error) {
        print('------> ERROR POSTS  ${error.toString()}');

        emit(SocialGetPostErrorDataState(error.toString()));
      },
    );
  }

  // void getPosts() {
  //   emit(SocialGetPostLoadingDataState());
  //   FirebaseFirestore.instance.collection('posts').get().then((value) {
  //     for (var element in value.docs) {
  //       // element.reference.collection('likes').get().then(
  //       //   (value) {
  //       //     likes.add(
  //       //       value.docs.length,
  //       //     );
  //       //   },
  //       // ).catchError(
  //       //   (error) {
  //       //     print('------> ERROR POSTS  ${error.toString()}');
  //       //   },
  //       // );
  //       posts.add(
  //         PostModel.fromJSON(
  //           element.data(),
  //         ),
  //       );
  //       postsId.add(
  //         element.id.toString(),
  //       );
  //       print('------> ALL POSTS ${posts[0].text}');
  //     }
  //     emit(SocialGetPostSuccessDataState());
  //   }).catchError(
  //     (error) {
  //       print('------> ERROR POSTS  ${error.toString()}');
  //
  //       emit(SocialGetPostErrorDataState(error.toString()));
  //     },
  //   );
  // }

  void likePost(String postID) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(userID)
        .set({
      'like': true,
    }).then(
      (value) {
        getPostsStreamBuilder();
        emit(SocialLikePostSuccessState());
      },
    ).catchError(
      (error) {
        emit(
          SocialLikePostErrorState(
            error.toString(),
          ),
        );
      },
    );
  }

  List<UserModel> users = [];
  void getAllUsers() {
    emit(SocialGetAllUsersLoadingDataState());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userID) {
            users.add(UserModel.fromJSON(element.data()));
          }
        }
        emit(SocialGetAllUsersSuccessDataState());
      }).catchError(
        (error) {
          emit(SocialGetAllUsersErrorDataState(error.toString()));
        },
      );
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: userID!,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );

    //set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(
          messageModel.toMap(),
        )
        .then(
      (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialSendMessageErrorState());
      },
    );
    //set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userID)
        .collection('messages')
        .add(
          messageModel.toMap(),
        )
        .then(
      (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialSendMessageErrorState());
      },
    );
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy(
          'dateTime',
          descending: true,
        )
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(
          MessageModel.fromJSON(
            element.data(),
          ),
        );
      }
      emit(SocialGetMessageSuccessState());
    });
  }

  bool isChatButtonEnables = false;
  void checkEnabledButtonChat(String value) {
    if (value.isNotEmpty) {
      isChatButtonEnables = true;
      emit(SocialCheckChatButtonSuccessState());
    } else {
      isChatButtonEnables = false;
      emit(SocialCheckChatButtonErrorState());
    }
  }
}

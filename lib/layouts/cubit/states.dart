abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserLoadingDataState extends SocialStates {}

class SocialGetUserSuccessDataState extends SocialStates {}

class SocialGetUserErrorDataState extends SocialStates {
  final String error;

  SocialGetUserErrorDataState(this.error);
}

class SocialGetAllUsersLoadingDataState extends SocialStates {}

class SocialGetAllUsersSuccessDataState extends SocialStates {}

class SocialGetAllUsersErrorDataState extends SocialStates {
  final String error;

  SocialGetAllUsersErrorDataState(this.error);
}

class SocialGetPostLoadingDataState extends SocialStates {}

class SocialGetPostSuccessDataState extends SocialStates {}

class SocialGetPostErrorDataState extends SocialStates {
  final String error;

  SocialGetPostErrorDataState(this.error);
}

class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}

class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageSuccessState extends SocialStates {}

class SocialUploadCoverImageErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

// create post
class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

// For Like The Post
class SocialLikePostSuccessState extends SocialStates {}

class SocialLikePostErrorState extends SocialStates {
  final String error;

  SocialLikePostErrorState(this.error);
}

// chat application
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessageSuccessState extends SocialStates {}

class SocialCheckChatButtonSuccessState extends SocialStates {}

class SocialCheckChatButtonErrorState extends SocialStates {}

// get All users register from application
class SocialGetAllUsersRegisterSuccessState extends SocialStates {}

class SocialGetAllUsersRegisterErrorState extends SocialStates {}

class SocialTimerStarterState extends SocialStates {}

class SocialTimerCancelState extends SocialStates {}

class SocialTimerReturnState extends SocialStates {}

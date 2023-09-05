abstract class HomeStates {}
class HomeInitialState extends HomeStates {}
class HomeLoadingState extends HomeStates {}
class HomeSuccessState extends HomeStates {}
class HomeErrorState extends HomeStates {
  final String error;
  HomeErrorState(this.error);
}

class HomeGetUserSuccessState extends HomeStates {}
class HomeGetUserLoadingState extends HomeStates {}
class HomeGetUserErrorState extends HomeStates {
  final String error;
  HomeGetUserErrorState(this.error);
}

class HomeSearchSuccessState extends HomeStates {}
class HomeSearchLoadingState extends HomeStates {}
class HomeSearchErrorState extends HomeStates {
  final String error;
  HomeSearchErrorState(this.error);
}





class HomeGetAllUserSuccessState extends HomeStates {}
class HomeGetAllUserLoadingState extends HomeStates {}
class HomeGetAllUserErrorState extends HomeStates {
  final String error;
  HomeGetAllUserErrorState(this.error);
}

class HomeGetAllUserWithMeSuccessState extends HomeStates {}
class HomeGetAllUserWithMeLoadingState extends HomeStates {}
class HomeGetAllUserWithMeErrorState extends HomeStates {
  final String error;
  HomeGetAllUserWithMeErrorState(this.error);
}


class HomeChangeBottomNavBarState extends HomeStates {}
class HomeNewPostState extends HomeStates {}
class HomeProfileImagePickedSuccessState extends HomeStates {}
class HomeProfileImagePickedErrorState extends HomeStates {}

class HomeCoverImagePickedSuccessState extends HomeStates {}
class HomeCoverImagePickedErrorState extends HomeStates {}

class HomeUploadProfileImageSuccessState extends HomeStates {}
class HomeUploadProfileImageErrorState extends HomeStates {}

class HomeUploadCoverImageSuccessState extends HomeStates {}
class HomeUploadCoverImageErrorState extends HomeStates {}

class HomeUserUpdateLoadingState extends HomeStates {}
class HomeUserUpdateErrorState extends HomeStates {}






// Create Post
class HomeCreatePostLoadingState extends HomeStates {}
class HomeCreatePostSuccessState extends HomeStates {}
  class HomeCreatePostErrorState extends HomeStates {}


class HomePostImagePickedSuccessState extends HomeStates {}
class HomePostImagePickedErrorState extends HomeStates {}
class HomeRemovePostImageState extends HomeStates {}



class HomeGetPostsForUserLoadingState extends HomeStates {}
class HomeGetPostsForUserSuccessState extends HomeStates {}
class HomeGetPostsForUserErrorState extends HomeStates {
  final String error;
  HomeGetPostsForUserErrorState(this.error);
}



class HomeGetPostsSuccessState extends HomeStates {}
class HomeGetPostsLoadingState extends HomeStates {}
class HomeGetPostsErrorState extends HomeStates {
  final String error;
  HomeGetPostsErrorState(this.error);
}




class HomeGetFollowersSuccessState extends HomeStates {}
class HomeGetFollowersLoadingState extends HomeStates {}
class HomeGetFollowersErrorState extends HomeStates {
  final String error;
  HomeGetFollowersErrorState(this.error);
}

class HomeGetFollowingSuccessState extends HomeStates {}
class HomeGetFollowingLoadingState extends HomeStates {}
class HomeGetFollowingErrorState extends HomeStates {
  final String error;
  HomeGetFollowingErrorState(this.error);
}




class HomeGetCommentsSuccessState extends HomeStates {}
class HomeGetCommentsLoadingState extends HomeStates {}
class HomeGetCommentsErrorState extends HomeStates {
  final String error;
  HomeGetCommentsErrorState(this.error);
}







class HomeGetPostsProfileSuccessState extends HomeStates {}
class HomeGetPostsProfileLoadingState extends HomeStates {}
class HomeGetPostsProfileErrorState extends HomeStates {
  final String error;
  HomeGetPostsProfileErrorState(this.error);
}



class HomeSavePostSuccessState extends HomeStates {}
class HomeSavePostLoadingState extends HomeStates {}
class HomeSavePostErrorState extends HomeStates {
  final String error;
  HomeSavePostErrorState(this.error);
}
class HomeUnSavePostSuccessState extends HomeStates {}
class HomeUnSavePostLoadingState extends HomeStates {}
class HomeUnSavePostErrorState extends HomeStates {
  final String error;
  HomeUnSavePostErrorState(this.error);
}

class HomeCheckSavePostState extends HomeStates {}



class HomeGetSavePostSuccessState extends HomeStates {}
class HomeGetSavePostLoadingState extends HomeStates {}
class HomeGetSavePostErrorState extends HomeStates {
  final String error;
  HomeGetSavePostErrorState(this.error);
}

class HomeGetLikesPostSuccessState extends HomeStates {}
class HomeGetLikesPostLoadingState extends HomeStates {}
class HomeGetLikesPostErrorState extends HomeStates {
  final String error;
  HomeGetLikesPostErrorState(this.error);
}

class HomeGetPostsByIdLoadingState extends HomeStates {}
class HomeGetPostsByIdSuccessState extends HomeStates {}
class HomeGetPostsByIdErrorState extends HomeStates {
  final String error;
  HomeGetPostsByIdErrorState(this.error);
}





class HomeLikePostSuccessState extends HomeStates {}
class HomeCheckLikePostState extends HomeStates {}
class HomeLikePostLoadingState extends HomeStates {}
class HomeLikePostErrorState extends HomeStates {
  final String error;
  HomeLikePostErrorState(this.error);
}
class HomeDisLikePostSuccessState extends HomeStates {}
class HomeDisLikePostLoadingState extends HomeStates {}
class HomeDisLikePostErrorState extends HomeStates {
  final String error;
  HomeDisLikePostErrorState(this.error);
}
class HomeChangeLikeColorState extends HomeStates {}



class HomeCommentPostSuccessState extends HomeStates {}
class HomeCommentPostLoadingState extends HomeStates {}
class HomeCommentPostErrorState extends HomeStates {
  final String error;
  HomeCommentPostErrorState(this.error);
}


class HomeCommentSendState extends HomeStates {
  int length;
  HomeCommentSendState(this.length);
}

class HomeSendMessageSuccessState extends HomeStates {}
class HomeSendMessageErrorState extends HomeStates {
  final String? error;
  HomeSendMessageErrorState(this.error);
}

class HomeGetMessagesSuccessState extends HomeStates {}


class HomeChangeButtonFollowState extends HomeStates {}

//delete post
class HomeDeletePostSuccessState extends HomeStates {}
class HomeDeletePostErrorState extends HomeStates {
  final String error;
  HomeDeletePostErrorState(this.error);
}
//update post
class HomeUpdatePostSuccessState extends HomeStates {}
class HomeUpdatePostErrorState extends HomeStates {
  final String error;
  HomeUpdatePostErrorState(this.error);
}


class HomeFollowUserSuccessState extends HomeStates {}
class HomeFollowUserErrorState extends HomeStates {
  final String error;
  HomeFollowUserErrorState(this.error);
}
class HomeUnFollowUserSuccessState extends HomeStates {}
class HomeUnFollowUserErrorState extends HomeStates {
  final String error;
  HomeUnFollowUserErrorState(this.error);
}

// class HomeGetMessagesErrorState extends HomeStates {}













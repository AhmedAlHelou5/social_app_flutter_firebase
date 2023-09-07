import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:social_app_flutter_firebase/models/message/message_model.dart';
import 'package:social_app_flutter_firebase/models/post/comment_model.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/modules/feeds/comment_screen.dart';
import 'package:social_app_flutter_firebase/modules/new_post/edit_post.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../models/post/post_model.dart';
import '../../modules/feeds/likes_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../styles/colors/colors.dart';
import 'constants.dart';

Widget buildDivider() =>
    Container(
      height: 24,
      child: VerticalDivider(
        color: Colors.grey,
      ),
    );

Widget myDivider() =>
    Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, Widget widget) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
            (route) => false);

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType? type,
  required validate,
  String? label,
  String? hint,
  IconData? prefix,
  IconData? suffix,
  VoidCallback? suffixPresed,
  int? maxLength,
  int? maxLines,
  onSubmit,
  onTap,
  onChange,
  onSaved,
  bool? isPassword = false,
  bool? isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword!,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      enabled: isClickable,
      onTap: onTap,
      enableSuggestions: true,
      onSaved: onSaved,
      autocorrect: true,
      // textDirection: TextDirection.ltr,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(suffix),
          onPressed: suffixPresed,
        )
            : null,
        prefixIcon: Icon(
          prefix,
        ),
        focusColor: Colors.blue,
        border: OutlineInputBorder(),
      ),
    );

// Widget buildMessage(MessageModel? message, context) =>
//     Align(
//       alignment: AlignmentDirectional.centerStart,
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.grey[300],
//             // color: defaultColor.withOpacity(.2),
//             borderRadius: const BorderRadiusDirectional.only(
//               topEnd: Radius.circular(10),
//               topStart: Radius.circular(10),
//               bottomEnd: Radius.circular(10),
//             )),
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Text('${message!.text}',
//             style: Theme
//                 .of(context)
//                 .textTheme
//                 .caption!
//                 .copyWith(
//                 height: 1.4,
//                 fontSize: 14,
//                 color: Colors.black.withOpacity(0.8))),
//       ),
//     );
//other
Widget buildMyMessage(MessageModel message,UserModel? model,index,context, {Key? key}){
  var cubit = HomeCubit.get(context);

  cubit.isMe=cubit.messages[index].senderId == model!.uId?false:true;

  return Align(
    alignment:!cubit.isMe!? AlignmentDirectional.centerStart: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        // color: Colors.grey[300],
          color:cubit.isMe!?defaultColor.withOpacity(.2):Colors.grey[300],
          borderRadius:  BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            bottomStart:cubit.isMe! ? Radius.circular(10): Radius.circular(0),
            bottomEnd:cubit.isMe! ? Radius.circular(0): Radius.circular(10),
          )),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text('${message.text}',
          style: Theme
              .of(context)
              .textTheme
              .caption!
              .copyWith(
              height: 1.4,
              fontSize: 14,
              color: Colors.black.withOpacity(0.8))),
    ),
  );

}

Widget buildPostItem(PostModel?  model,
    context,
    int? index,
    {commentController, isSearch = false, isHome = false}) {
  // bool buttonClicked = false;
  // HomeCubit.get(context).getLikesPost(postId: model!.postId);

  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5,
    margin: EdgeInsets.symmetric(
      horizontal: 8,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('${model!.image}'),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${model.name}',
                        style: TextStyle(height: 1.4),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.check_circle,
                        color: defaultColor,
                        size: 16,
                      ),
                    ],
                  ),
                  Text(
                    ' ${DateFormat.jmv().format(DateTime.parse(
                        model.dateTime!)) as String}  ${DateFormat.yMMMMd()
                        .format(DateTime.parse(model.dateTime!)) as String}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption!
                        .copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15),
            if(isHome == false)
                  PopupMenuButton<_MenuValues>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (BuildContext context) => [
                      // PopupMenuItem(
                      //   child: Text('Edit Post'),
                      //   value: _MenuValues.edit,
                      // ),
                      PopupMenuItem(
                        child: Text('Save Post'),
                        value: _MenuValues.save,
                      ),
                      PopupMenuItem(
                        child: Text('Delete Post'),
                        value: _MenuValues.delete,
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {

                        case _MenuValues.save:
                          var cubit=HomeCubit.get(context);
                        cubit.SavePost(
                            postId: model.postId,

                          );

                         HomeCubit.get(context).getSavePost();
                        print('_MenuValues.save ${model.postImage}');
                        print('_MenuValues.save ${model.image}');
                        print('_MenuValues.save ${model.text}');
                        print('_MenuValues.save ${model.dateTime}');
                        print('_MenuValues.save ${model.likes!.length}');
                        print('_MenuValues.save ${model.comments!.length}');

                         print('_MenuValues.save ${model!.postId}');

                          break;
                        case _MenuValues.delete:
                          HomeCubit.get(context).deletePost(
                            postId: model!.postId,
                          );
                          print('_MenuValues.delete ${model!.postId}');
                          break;

                      // case _MenuValues.edit:
                      //   // navigateTo(context, EditPostScreen(model));
                      //   print('_MenuValues.edit ${model!.postId}');
                      //
                      //   break;
                      }


                  },
                icon: Icon(
                  Icons.more_horiz,
                  size: 16,
                )
                  ),
          ]),
          // myDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              height: 1,
              color: Colors.grey[300],
              width: double.infinity,
            ),
          ),
          Text(
            '${model.text}',
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //         children: [
          //           Padding(
          //             padding: EdgeInsetsDirectional.only(end: 6),
          //             child: Container(
          //               height: 20,
          //               child: MaterialButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   '#Software',
          //                   style: Theme
          //                       .of(context)
          //                       .textTheme
          //                       .caption!
          //                       .copyWith(
          //                     color: defaultColor,
          //                   ),
          //                 ),
          //                 minWidth: 1,
          //                 padding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsetsDirectional.only(end: 6),
          //             child: Container(
          //               height: 20,
          //               child: MaterialButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   '#Software',
          //                   style: Theme
          //                       .of(context)
          //                       .textTheme
          //                       .caption!
          //                       .copyWith(
          //                     color: defaultColor,
          //                   ),
          //                 ),
          //                 minWidth: 1,
          //                 padding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsetsDirectional.only(end: 6),
          //             child: Container(
          //               height: 20,
          //               child: MaterialButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   '#Software',
          //                   style: Theme
          //                       .of(context)
          //                       .textTheme
          //                       .caption!
          //                       .copyWith(
          //                     color: defaultColor,
          //                   ),
          //                 ),
          //                 minWidth: 1,
          //                 padding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsetsDirectional.only(end: 6),
          //             child: Container(
          //               height: 20,
          //               child: MaterialButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   '#Software',
          //                   style: Theme
          //                       .of(context)
          //                       .textTheme
          //                       .caption!
          //                       .copyWith(
          //                     color: defaultColor,
          //                   ),
          //                 ),
          //                 minWidth: 1,
          //                 padding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsetsDirectional.only(end: 6),
          //             child: Container(
          //               height: 20,
          //               child: MaterialButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   '#Software',
          //                   style: Theme
          //                       .of(context)
          //                       .textTheme
          //                       .caption!
          //                       .copyWith(
          //                     color: defaultColor,
          //                   ),
          //                 ),
          //                 minWidth: 1,
          //                 padding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsetsDirectional.only(end: 6),
          //             child: Container(
          //               height: 20,
          //               child: MaterialButton(
          //                 onPressed: () {},
          //                 child: Text(
          //                   '#Software',
          //                   style: Theme
          //                       .of(context)
          //                       .textTheme
          //                       .caption!
          //                       .copyWith(
          //                     color: defaultColor,
          //                   ),
          //                 ),
          //                 minWidth: 1,
          //                 padding: EdgeInsets.zero,
          //               ),
          //             ),
          //           ),
          //
          //
          //         ]
          //     ),
          //   ),
          // ),
          if (model.postImage != '')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 15),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${model.postImage}',
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          LikeScreen(
                            postId: model.postId,
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${model.likes!.length} '??'0'  ,
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // dialogBuilder(HomeCubit.get(context).comments, context, index, commentController, likes);
                      navigateTo(
                          context,
                          CommentScreen(
                            postId: model!.postId,
                          ));
                      print('HomeCubit.get(context).postsId[index!] ${model
                          .postId}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.chat,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${model.comments!.length} comment'?? '0',
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 1,
              color: Colors.grey[300],
              width: double.infinity,
            ),
          ),
          if(isSearch == false)
            Row(

              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                  model.image != null || model.image != ''
                      ? NetworkImage('${model!.image}')
                      : Image
                      .asset('assets/images/person.png')
                      .image,
                ),
                SizedBox(width: 15),
                if(isSearch == false)
                  Expanded(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.6,
                      child: TextFormField(
                        controller: commentController,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: 'write a comment ...',
                            border: InputBorder.none),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'comment must not be empty';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          HomeCubit.get(context).changeLength(val.length);
                        },
                      ),
                    ),
                  ),
                // if( commentController.text.length > 0)
                //    SizedBox(width: 15),
                //
                if(isSearch == true)
                  Spacer(),


                if(isSearch == false)
                  if (commentController.text.length > 0)
                    sendToComment(
                        context,
                        model.postId,
                        index,
                        commentController,
                        HomeCubit
                            .get(context)
                            .model!
                            .name,
                        HomeCubit
                            .get(context)
                            .model!
                            .image,
                        uId),

                InkWell(
                  onTap: () {
                    var cubit = HomeCubit.get(context);
                    // HomeCubit.get(context).followers! +1 ;

                    print('cubit.buttonClicked ${cubit.buttonClicked}');
                    cubit.buttonClicked  ? cubit.likePost(
                      postId:model.postId,

                    ) : cubit.likePost(
                      postId: model.postId,

                    );
                    HomeCubit.get(context).changeLikeButton();

                    // HomeCubit.get(context).changeLikeButton();

                    // cubit.buttonClicked=!cubit.buttonClicked;

                  },

                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Like',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption,
                      ),
                    ],
                  ),
                )
              ],
            )
        ],
      ),
    ),
  );
}

Widget sendToComment(context, postId, index, controller, name, image, id) {
  return Expanded(
    flex: 1,
    child: IconButton(
        color: defaultColor,
        onPressed: () {
          print('Send');
          HomeCubit.get(context).commentPost(
              postId: postId,
              dateTime: DateTime.now().toString(),
              text: controller.text,
              image: image,
              name: name);
          controller.clear();
        },
        icon: Icon(
          Icons.send,
        )),
  );
}

PreferredSizeWidget? defaultAppBar({
  String? title,
  required BuildContext context,
  List<Widget>? actions,
}) =>
    AppBar(
      title: Text(
        title!,
      ),
      titleSpacing: 5,
      actions: actions,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          size: 16,
        ),
      ),
    );

Widget defaultButton({
  double wid = double.infinity,
  double height = 45,
  double radius = 0.0,
  Color background = Colors.blue,
  bool isUpperCase = true,
  required VoidCallback? function,
  required String text,
}) =>
    Container(
      width: wid,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );


Widget followAndUnfollowButton({
  required bool isFollowing,
  required String? id2,
  required String? id1,
  // required String? name1,
  // required String? image1,
  required String? name2,
  required String? image2,
  context
}) {
  return isFollowing == false ? Expanded(
    child: defaultButton(
        function: () {
          HomeCubit.get(context).followUser(
              uid: id1,
              followId: id2,
              image: HomeCubit
                  .get(context)
                  .model!
                  .image!,
              name: HomeCubit
                  .get(context)
                  .model!
                  .name!,
              image2: image2,
              name2: name2

          );
          // HomeCubit.get(context).followers! +1 ;

          HomeCubit.get(context).changeFollowButton();
          // HomeCubit.get(context).getFollowerForUser(id2);
        }, text: 'Follow', radius: 20, height: 35),
  ) :
  Expanded(child: defaultTextButton(function: () {
    HomeCubit.get(context).followUser(
        uid: id1,
        followId: id2,
        image: HomeCubit
            .get(context)
            .model!
            .image!,
        name: HomeCubit
            .get(context)
            .model!
            .name!,
        image2: image2,
        name2: name2);

    HomeCubit.get(context).changeFollowButton();
    // HomeCubit.get(context).getFollowerForUser(id2);

  }, text: 'Unfollow',));
  // HomeCubit.get(context).getFollowerForUser(id2);


}


Widget defaultTextButton({
  required VoidCallback? function,
  required String text,
  double wid = 100,
  double radius = 0.0,
  double height = 45,
}) =>
    Container(

      width: wid,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextButton(
          onPressed: function,
          child: Text(
            text.toUpperCase(),

          )),
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
dynamic selectedMenu = 0;
//
// Widget buildMenuPostItem()=>PopupMenuButton(
//   initialValue: selectedMenu,
//   // Callback that sets the selected popup menu item.
//   onSelected: ( item) {
//       selectedMenu = item;
//
//   },
//   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//     const PopupMenuItem(
//       value: Icon(Icons.edit),
//       child: Text('Edit post'),
//     ),
//     const PopupMenuItem(
//       value: Icon(Icons.delete_forever),
//       child: Text('delete post'),
//     ),
//
//   ],
// );


// Widget buildCardMenuForPost(BuildContext context, {String? text, String? postId}) => FocusedMenuHolder(
//   menuItems: [
//     FocusedMenuItem(
//       title: Text('update', style: TextStyle(color: Colors.white)),
//       trailingIcon: Icon(Icons.edit),
//       onPressed: () => HomeCubit.get(context).updatePost(postId: postId, text: text),
//     ),
//     FocusedMenuItem(
//       title: Text('Delete', style: TextStyle(color: Colors.white)),
//       trailingIcon: Icon(Icons.delete_forever, color: Colors.white),
//       backgroundColor: Colors.red,
//       onPressed: () => HomeCubit.get(context).deletePost(postId: postId),
//     ),
//   ],
//   blurSize: 8,
//   blurBackgroundColor: Colors.white,
//   menuWidth: MediaQuery.of(context).size.width * 0.5,
//   menuItemExtent: 50,
//   duration: Duration(seconds: 0),
//   animateMenuItems: false,
//   menuOffset: 12,
//   openWithTap: true,
//   onPressed: () {},
//   child: Container(
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.white),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: SizedBox(
//       width: MediaQuery.of(context).size.width * 0.5,
//       child: Center(
//         child: Text(
//           text!,
//
//         )
//       )
//     )),
//
// );

Widget buildItemDrawer(
    {required Widget? icon,Function()? onTap,required String? title, Color? color, FontWeight? weight,double? fontSize})=>ListTile(
  leading: icon,
  onTap:onTap ,
  title: Text('$title',style: TextStyle(color: color,fontWeight: weight,fontSize:fontSize ,letterSpacing: 1),),
);

enum _MenuValues {
  // edit,
  delete,
  save,
}




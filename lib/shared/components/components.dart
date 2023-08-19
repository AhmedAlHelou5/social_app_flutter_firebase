import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:social_app_flutter_firebase/models/message/message_model.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../models/post/post_model.dart';
import '../styles/colors/colors.dart';


// Widget buildArticleItem(article,context) => InkWell(
//   onTap: () {
//     navigateTo(context, WebViewScreen(url: '${article['url']}'));
//   },
//   child:   Padding(
//
//     padding: const EdgeInsets.all(15.0),
//
//     child: Row(
//
//         children: [
//
//           Expanded(
//
//             child: Container(
//
//               width: 120,
//
//               height: 120,
//
//               decoration: BoxDecoration(
//
//                   borderRadius: BorderRadius.circular(10),
//
//                   image: DecorationImage(
//
//                     image: NetworkImage(
//
//                       '${article['urlToImage']}',
//
//                     ),
//
//                     fit: BoxFit.cover,
//
//
//
//                   )
//
//               ),
//
//             ),
//
//           ),
//
//           SizedBox(width: 20,),
//
//           Expanded(
//
//               child: Container(
//
//                 height: 130,
//
//                 child: Column(
//
//                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                     mainAxisSize: MainAxisSize.min,
//
//                     mainAxisAlignment: MainAxisAlignment.start,
//
//                     children: [
//
//                       Text('${article['title']}',maxLines: 3,overflow: TextOverflow.ellipsis,style:Theme.of(context).textTheme.bodyText1,),
//
//                       SizedBox(height: 10,),
//
//                       Text('${article['publishedAt']}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
//
//                     ]
//
//                 ),
//
//               )
//
//           )
//
//         ]
//
//     ),
//
//   ),
// );
//
// Widget articleBuilder(list,context,{isSearch=false}) => ConditionalBuilder(
//   condition: list.length > 0,
//   builder: (context) => ListView.separated(
//     physics: BouncingScrollPhysics(),
//     itemBuilder: (context,index) => buildArticleItem(list[index],context),
//     separatorBuilder: ( context,index) =>myDivider(),
//     itemCount: list.length,
//   ),
//   fallback: (context) =>isSearch ? Container(): Center(child: CircularProgressIndicator()),
// );
//
//
//
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
            (route) => false
    );


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
        suffixIcon: suffix != null ? IconButton(
          icon: Icon(suffix), onPressed: suffixPresed,) : null,

        prefixIcon: Icon(
          prefix,
        ),
        focusColor: Colors.blue,

        border: OutlineInputBorder(),
      ),
    );




Widget buildMessage(MessageModel message,context, {Key? key}) =>
    Align(
  alignment: AlignmentDirectional.centerStart,

  child: Container(
    decoration: BoxDecoration(
        color: Colors.grey[300],
        // color: defaultColor.withOpacity(.2),
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        )

    ),
    padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10
    ),
    child: Text('${message.text}', style: Theme
        .of(context)
        .textTheme
        .caption!
        .copyWith(height: 1.4,
        fontSize: 14,
        color: Colors.black.withOpacity(0.8))),

  ),
);

Widget buildMyMessage(MessageModel message,context, {Key? key}) =>
    Align(
        alignment: AlignmentDirectional.centerEnd,

        child: Container(

          decoration: BoxDecoration(
            // color: Colors.grey[300],
              color: defaultColor.withOpacity(.2),
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
                bottomStart: Radius.circular(10),
              )

          ),
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10
          ),
          child: Text('${message.text}', style: Theme
              .of(context)
              .textTheme
              .caption!
              .copyWith(height: 1.4,
              fontSize: 14,
              color: Colors.black.withOpacity(0.8))),

        ),
      );










Widget buildPostItem(PostModel? model, context, int? index, commentController,
   int? likes,int? comments) =>
    Card(
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
            Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        '${model!.image}'),
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
                              model.dateTime!)) as String}  ${DateFormat
                              .yMMMMd().format(
                              DateTime.parse(model.dateTime!)) as String}',
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
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 16,
                      )),
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
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 16,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text('${likes} ',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption,),
                          ],

                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.chat,
                              size: 16,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 5),
                            Text('${comments} comment', style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
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

            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                      '${HomeCubit
                          .get(context)
                          .model!
                          .image}'),
                ),
                SizedBox(width: 15),

                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: TextFormField(

                                controller: commentController,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: 'write a comment ...',
                                    border: InputBorder.none
                                ),
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
                          if( commentController.text.length > 0)
                            sendToComment(
                                context, index, commentController),

                InkWell(
                  onTap: () {
                    HomeCubit.get(context).likeOrDislikePost(HomeCubit
                        .get(context)
                        .postsId[index!], );
                    // HomeCubit.get(context).changeLikeOrDisLikePostColor(HomeCubit.get(context).postsId[index!]);
                  },
                  child: Row(
                    children: [
                      Icon(
                       Icons.favorite_border,
                        size: 16,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5),
                      Text('Like', style: Theme
                          .of(context)
                          .textTheme
                          .caption,),
                    ],

                  ),
                )

              ],
            )


          ],
        ),
      ),
    );


Widget sendToComment(context, index, controller) =>
    Expanded(
      flex: 1,
      child: IconButton(
          color: defaultColor,
          onPressed: () {
            print('Send');
            HomeCubit.get(context).commentPost(HomeCubit
                .get(context)
                .postsId[index], controller.text);
            controller.clear();
          },
          icon: Icon(
            Icons.send,
          )),
    );


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
        icon: Icon(Icons.arrow_back_ios, size: 16,),
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

Widget defaultTextButton({
  required VoidCallback? function,
  required String text,
  double wid = 100,

}) =>
    TextButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),


        ));

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



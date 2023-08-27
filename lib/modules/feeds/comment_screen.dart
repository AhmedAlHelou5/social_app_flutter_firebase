import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/models/post/comment_model.dart';
import 'package:social_app_flutter_firebase/models/post/post_model.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors/colors.dart';

class CommentScreen extends StatelessWidget {
  String? postId;

  CommentScreen({required this.postId});

  var commentController = TextEditingController();
  // get index => HomeCubit().posts!.indexWhere((element) => element!.uId== postId);


  @override
  Widget build(BuildContext context) {
    // HomeCubit.get(context).getCommentPost(postId: postId);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var model = cubit.posts;

        return Scaffold(
            appBar: AppBar(title: Text('Comments'), centerTitle: true),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConditionalBuilder(
                condition:cubit.posts[cubit.postsId.indexOf(postId)]!.comments!.length > 0,
              builder: (context) =>  ListView.separated(

                itemBuilder: (context, index) {

                  return buildCommentItem(
                      cubit.posts[cubit.postsId.indexOf(postId)]!.comments![index],  context, index,commentController);
                },
                itemCount:cubit.posts[cubit.postsId.indexOf(postId)]!.comments!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 8),
              ),
              fallback:(context) => Center(
                child: Text('No Comments in This Post'),
              ),


              ),
            ),

        );
      },
    );
  }

  Widget buildCommentItem(
       model,
      context,
      int? index,
      commentController,
      ) {
    // bool buttonClicked = false;

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
                      ' ${model.text!}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(height: 1.4),
                    ),

                    Text(
                      ' ${DateFormat.jmv().format(DateTime.parse(model.dateTime!)) as String}  ${DateFormat.yMMMMd().format(DateTime.parse(model.dateTime!)) as String}',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15),

            ]),
            // myDivider(),


          ],
        ),
      ),
    );
  }








  //
  // Widget buildCommentItem(context, index,CommentModel model, commentController) {
  //   // var cubit = HomeCubit.get(context);
  //   //  model = cubit.posts;
  //   // var commentModel = CommentModel.fromJson(model!.comments as Map<String, dynamic>);
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //         children: [
  //       Row(
  //           children: [
  //         CircleAvatar(
  //           radius: 15,
  //           backgroundImage: NetworkImage('${model.image}'),
  //         ),
  //         SizedBox(width: 15),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Column(
  //                     children: [
  //                       Text(
  //                         '${model!.name}',
  //                       ),
  //                       if (model.text != null)
  //                         Text(
  //                           '${model.text}',
  //                         ),
  //                     ],
  //                   ),
  //                   SizedBox(width: 5),
  //                   Icon(
  //                     Icons.check_circle,
  //                     color: defaultColor,
  //                     size: 16,
  //                   ),
  //                 ],
  //               ),
  //               Text(
  //                 ' ${DateFormat.jmv().format(DateTime.parse(model.dateTime!)) as String}'
  //                     '  ${DateFormat.yMMMMd().format(DateTime.parse(model!.dateTime!))}',
  //                 style:
  //                     Theme.of(context).textTheme.caption!.copyWith(height: 1.4),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ]),
  //       SizedBox(width: 15),
  //       Expanded(
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.6,
  //           child: TextFormField(
  //             controller: commentController,
  //             keyboardType: TextInputType.text,
  //             maxLines: 1,
  //             decoration: const InputDecoration(
  //                 hintText: 'write a comment ...', border: InputBorder.none),
  //             validator: (String? value) {
  //               if (value!.isEmpty) {
  //                 return 'comment must not be empty';
  //               }
  //               return null;
  //             },
  //             onChanged: (val) {
  //               HomeCubit.get(context).changeLength(val.length);
  //             },
  //           ),
  //         ),
  //       ),
  //       // if( commentController.text.length > 0)
  //       //    SizedBox(width: 15),
  //
  //       if (commentController.text.length > 0)
  //         sendToComment(
  //             context,
  //             index,
  //             commentController.text,
  //             HomeCubit.get(context).model!.name,
  //             HomeCubit.get(context).model!.image,
  //             HomeCubit.get(context).model!.uId),
  //     ]),
  //   );
  // }
}

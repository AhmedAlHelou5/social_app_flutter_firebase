import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors/colors.dart';

class CommentScreen extends StatelessWidget {
   String? postId;
   CommentScreen({required this.postId});
   var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // HomeCubit.get(context).getComments(postId: postId);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var model = cubit.commentModel;
        return Scaffold(
          appBar: AppBar(),
          body:Container(),
          // ListView.separated(
          //   itemBuilder: (context, index) {
          //     // print(cubit.comments.length);
          //
          //     // return buildCommentItem(
          //     //     context,index, cubit.comments[index], commentController
          //     // );
          //
          //   },
          //   itemCount: cubit.comments.length,
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   separatorBuilder: (BuildContext context, int index) =>
          //       SizedBox(height: 8),)



        );
      },
    );
  }

Widget buildCommentItem(context,index,model, commentController)=>
  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            children: [
              CircleAvatar(
                radius: 15,
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
                        Column(
                          children: [
                            Text(
                              '${model!.name}',
                            ),
                            if(model!.text != null)
                              Text(
                                '${model!.text}',
                              ),
                          ],
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

            ]),
        SizedBox(width: 15),
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

        if( commentController.text.length > 0)
          sendToComment(
              context, index, commentController,model.name ,model.image,model.uId),
      ]

  );
}




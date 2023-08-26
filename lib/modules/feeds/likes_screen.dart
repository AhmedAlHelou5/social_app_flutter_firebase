import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/models/post/comment_model.dart';
import 'package:social_app_flutter_firebase/models/post/post_model.dart';

import '../../models/user/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors/colors.dart';

class LikeScreen extends StatelessWidget {
  String? postId;

  LikeScreen({required this.postId});

  // var commentController = TextEditingController();
  // get index => HomeCubit().posts!.indexWhere((element) => element!.uId== postId);

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getUser(id: postId);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var model = cubit.posts;

        return Scaffold(
          appBar: AppBar(title: Text('Likes'), centerTitle: true),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConditionalBuilder(

              condition: cubit.posts[cubit.postsId.indexOf(postId)]!.likes.length > 0,
              builder:(contex) => ListView.separated(
                itemBuilder: (context, index) {
                  print( cubit.posts[cubit.postsId.indexOf(postId)]!.likes[index]);
                  return buildLikeItem(
                      cubit.posts[cubit.postsId.indexOf(postId)]!.likes[index],
                      context,
                      index,
                      );
                },
                itemCount:
                    cubit.posts[cubit.postsId.indexOf(postId)]!.likes.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 8),
              ),
              fallback: (context) => Center(
                child: Text('No Likes in This Post'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLikeItem(
    model,
    context,
    int? index,
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
}

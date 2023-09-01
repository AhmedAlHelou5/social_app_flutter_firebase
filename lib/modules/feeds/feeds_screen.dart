
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/models/post/post_model.dart';
import 'package:social_app_flutter_firebase/shared/styles/colors/colors.dart';
import 'package:intl/intl.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import '../../shared/components/components.dart';

class FeedsScreen extends StatelessWidget {
   FeedsScreen({Key? key}) : super(key: key);
  // var commentController = TextEditingController();
   List<TextEditingController> commentController = [];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        HomeCubit.get(context).getPostsData();
      // HomeCubit.get(context).  getCommentPostsData(postId)
        return BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {
              // TODO: implement listener
              if(state is HomeCreatePostSuccessState)
                HomeCubit.get(context).getPostsData();
              if(state is HomeLikePostSuccessState || state is HomeDisLikePostSuccessState || state is HomeCommentPostSuccessState)
                HomeCubit.get(context).getPostsData();


            },
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              // cubit.getPostsData();
              return ConditionalBuilder(
                condition:  cubit.posts.length > 0 ,
                fallback: (BuildContext context) => Center(child: CircularProgressIndicator(),),

                builder:(BuildContext context) => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child:  Column(
                        children: [
                          Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.all(8),
                            child: Stack(
                                alignment: AlignmentDirectional.bottomEnd, children: [
                              Image(
                                image: NetworkImage(
                                  'https://img.freepik.com/free-photo/close-up-burnt-paper_23-2150158713.jpg?t=st=1690224270~exp=1690227870~hmac=1bb3ddeac9939d2f0667908e0e88aeae3d11d512bf21f76b261639432068551b&w=360',
                                ),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'communicate with friends',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.white),
                                  )),
                            ]),
                          ),
                          ListView.separated(
                            itemBuilder: (context, index) {
                            commentController.add(new TextEditingController());
                            // cubit.getComments(postId:cubit.postsId[index]);

                            //
                            // HomeCubit.get(context).getComments(postId:HomeCubit
                            //     .get(context)
                            //     .postsId[index]);
                            return buildPostItem(
                                cubit.posts[index],
                                context,
                                index,
                               commentController:  commentController[index] ,

                              );



                          },
                            itemCount: cubit.posts.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (BuildContext context, int index) =>
                                SizedBox(height: 8),),


                        ],
                      ),
                    ),

                    // fallback: (BuildContext context)=>Center(child: CircularProgressIndicator(),),



              );
            });
      }
    );
    // ConditionalBuilder(
    // condition:  cubit.posts.length > 0 && cubit.posts!=null,
    // builder: (BuildContext context) =>SingleChildScrollView(
    // physics: BouncingScrollPhysics(),
    // child: Column(
    // children: [
    // Card(
    // elevation: 5,
    // clipBehavior: Clip.antiAliasWithSaveLayer,
    // margin: EdgeInsets.all(8),
    // child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
    // Image(
    // image: NetworkImage(
    // 'https://img.freepik.com/free-photo/close-up-burnt-paper_23-2150158713.jpg?t=st=1690224270~exp=1690227870~hmac=1bb3ddeac9939d2f0667908e0e88aeae3d11d512bf21f76b261639432068551b&w=360',
    // ),
    // fit: BoxFit.cover,
    // width: double.infinity,
    // height: 200,
    // ),
    // Padding(
    // padding: EdgeInsets.all(8),
    // child: Text(
    // 'communicate with friends',
    // style: Theme
    //     .of(context)
    //     .textTheme
    //     .subtitle1!
    //     .copyWith(color: Colors.white),
    // )),
    // ]),
    // ),
    // ConditionalBuilder(
    // condition:  cubit.likes.length > 0 && cubit.likes!=null &&cubit.commentsLength.length > 0 && cubit.commentsLength!=null,
    // fallback: (BuildContext context)=>Center(child: CircularProgressIndicator(),),
    // builder:(BuildContext context)=>ListView.separated(itemBuilder: (context, index) {
    // return buildPostItem(cubit.posts[index],context,index,commentController,HomeCubit.get(context).likes[index!],HomeCubit.get(context).commentsLength[index]);
    // },itemCount: cubit.posts.length,shrinkWrap: true,
    // physics: NeverScrollableScrollPhysics(),
    // separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8),),
    // )  ,
    // SizedBox(height: 8),
    //
    //
    // ],
    // ),
    // ),
    // fallback: (BuildContext context)=>Center(child: CircularProgressIndicator(),),
    //
    // );
  }



}
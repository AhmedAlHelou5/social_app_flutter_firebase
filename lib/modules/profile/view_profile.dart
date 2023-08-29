import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import '../../shared/components/components.dart';
import '../edit_profile/edit_profile_screen.dart';

class ViewProfileScreen extends StatelessWidget {
  UserModel?   model;

  ViewProfileScreen({required this.model});
  List<TextEditingController> commentController = [];

  @override
  Widget build(BuildContext context) {
        HomeCubit.get(context).getPostForUser(model!.uId);
        var postsForUser = HomeCubit.get(context).postsForUser;

        return BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
            // TODO: implement listener
            // if(state is HomeCreatePostSuccessState)
            //   HomeCubit.get(context).getPostsData();
            // if(state is HomeLikePostSuccessState || state is HomeDisLikePostSuccessState)
            //   HomeCubit.get(context).getPostsData();

          },
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            // cubit.getPostForUser(model!.uId);


            print(postsForUser.length);
            // cubit.getFollowerForUser(model!.uId);

            // cubit.getPostsProfileData(model!.uId);

            // var model = HomeCubit.get(context).model;
            return Scaffold(

              appBar: AppBar(
                title: Text('Profile'),
                actions: [
                 IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {

                      }
                  ),
                ],


              ),

              body: SingleChildScrollView(

            physics: BouncingScrollPhysics(),
                child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height *0.28,
                        child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children:[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          '${model!.cover}',
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage:  NetworkImage(
                                    '${model!.image}',
                                  ),
                                ),
                              )

                            ]
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text( '${model!.name}',style: Theme.of(context).textTheme.bodyText1,),
                      Text( '${model!.bio}',style: Theme.of(context).textTheme.caption,),
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                      children: [
                                        Text('${postsForUser.length}',style: Theme.of(context).textTheme.subtitle2,),
                                        Text('posts',style: Theme.of(context).textTheme.caption,),


                                      ]
                                  ),
                                ),
                              ),
                              buildDivider(),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                      children: [
                                        Text('${model!.followers!.length}',style: Theme.of(context).textTheme.subtitle2,),
                                        Text('Followers',style: Theme.of(context).textTheme.caption,),


                                      ]
                                  ),
                                ),
                              ),
                              buildDivider(),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                      children: [
                                        Text('${model!.following!.length}',style: Theme.of(context).textTheme.subtitle2,),
                                        Text('Followings',style: Theme.of(context).textTheme.caption,),


                                      ]
                                  ),
                                ),
                              ),
                            ]
                        ),

                      ),

                      // followAndUnfollowButton(isFollowing: cubit.isFollowing,id1: cubit.model!.uId ,
                      //   id2: model!.uId,context:
                      // context,),
                      //
                      Divider(color: Colors.grey,height: 2,endIndent: 30,indent: 30,),

                      SizedBox(height: 10,),

                      ListView.separated(
                        itemBuilder: (context, index) {
                          print(cubit.postsForUser.length);

                          commentController.add(new TextEditingController());
                          return buildPostItem(
                            cubit.postsForUser[index],
                            context,
                            index,
                            commentController: commentController[index],
                          );



                        },
                        itemCount: postsForUser.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 8),),
                      SizedBox(height: 40,),





                    ]
                ),
              ),
            );
          },
        );

  }






}

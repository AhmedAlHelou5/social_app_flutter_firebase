import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/modules/chats/chat_details_screen.dart';
import 'package:social_app_flutter_firebase/modules/users/users_screen.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../search/search_screen.dart';

class ViewProfileScreen extends StatelessWidget {
  dynamic   model;

  ViewProfileScreen({required this.model});
  List<TextEditingController> commentController = [];

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getPostForViewProfile(model);
    HomeCubit.get(context).getFollowerForUser(model!.uId);
    // HomeCubit.get(context).getFollowerForUser(id2);
    // var postsForUser = HomeCubit.get(context).postsForUser;
        return BlocConsumer<HomeCubit, HomeStates>(

          listener: (context, state) {
            // // TODO: implement listener
            // if(state is HomeChangeButtonFollowState){
            //   HomeCubit.get(context).getFollowerForUser(model!.uId);
            // }

            if(state is HomeCreatePostSuccessState || state is HomeLikePostSuccessState || state is HomeDisLikePostSuccessState || state is HomeChangeButtonFollowState || state is HomeCommentPostSuccessState)
              HomeCubit.get(context).getPostForViewProfile(model);


          },
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            // cubit.getPostForViewProfile(model!.uId);
            print("postsForUser.length   ${cubit.postsForUser.length}");
            // print("postsForUser.length   ${cubit.postsForUser.first}");
            return Scaffold(

              appBar: AppBar(
                title: Text('Profile'),
                // leading: IconButton(
                //   icon: Icon(Icons.arrow_back),
                //   onPressed: () {
                //   navigateTo(context,UsersScreen() );
                //}
                // ),
                actions: [
                 IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        navigateTo(context, SearchScreen());

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
                                        Text('${cubit.postsForUser.length}',style: Theme.of(context).textTheme.subtitle2,),
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
                                        Text('${cubit!.followers!.length}',style: Theme.of(context).textTheme.subtitle2,),
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
                                        Text('${cubit!.following!.length}',style: Theme.of(context).textTheme.subtitle2,),
                                        Text('Followings',style: Theme.of(context).textTheme.caption,),


                                      ]
                                  ),
                                ),
                              ),
                            ]
                        ),

                      ),

                      Row(
                        children: [
                          SizedBox(width: 10,),
                             followAndUnfollowButton(
                              isFollowing: cubit.isFollowing!,
                              id1: uId,
                              name2: model!.name,
                              image2:model!.image,
                              id2: model!.uId,
                               context:
                            context,),
                          SizedBox(width: 10,),

                          Expanded(child: defaultButton(
                            radius: 20,height: 35
                            ,function: (){
                            navigateTo(context, ChatDetailsScreen(model: model,));
                          }, text: 'Message',)),
                          SizedBox(width: 10,),

                        ],
                      ),
                      SizedBox(height: 10,),


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
                            isSearch: false,
                            commentController: commentController[index],
                          );



                        },
                        itemCount: cubit.postsForUser.length,
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

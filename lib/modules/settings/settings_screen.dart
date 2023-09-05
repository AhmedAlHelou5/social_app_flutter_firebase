import 'package:cool_alert/cool_alert.dart';
import 'package:dialogs/dialogs/choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/modules/settings/save_posts_screen.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';
import '../../layout/home/cubit/cubit.dart';
import '../../shared/components/constants.dart';
import '../edit_profile/edit_profile_screen.dart';


class SettingsScreen extends StatelessWidget {
   SettingsScreen({Key? key}) : super(key: key);
  List<TextEditingController> commentController = [];

  @override
  Widget build(BuildContext context) {
    // HomeCubit.get(context).getPostForViewProfile(uId);
    HomeCubit.get(context).getPostForSettings();
    // HomeCubit.get(context).getSavePosteForUser();


    return BlocConsumer<HomeCubit, HomeStates>(
  listener: (context, state) {
    // TODO: implement listener
    if(state is HomeCreatePostSuccessState ||state is HomeLikePostSuccessState || state is HomeDisLikePostSuccessState || state is HomeCommentPostSuccessState)
      HomeCubit.get(context).getPostForSettings();

  },
  builder: (context, state) {
    var cubit = HomeCubit.get(context);
    // var model = HomeCubit.get(context).model;

    var postsForUser = HomeCubit.get(context).postsForSettings;

    return SingleChildScrollView(
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
                          '${cubit.model!.cover!}',
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
                     '${cubit.model!.image}',
                    ),
                  ),
                )

              ]
            ),
          ),
          SizedBox(height: 5,),
          Text( '${cubit.model!.name}',style: Theme.of(context).textTheme.bodyText1,),
          Text( '${cubit.model!.bio}',style: Theme.of(context).textTheme.caption,),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 15.0),
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
                            Text('${cubit.model!.followers!.length}',style: Theme.of(context).textTheme.subtitle2,),
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
                            Text('${cubit.model!.following!.length}',style: Theme.of(context).textTheme.subtitle2,),
                            Text('Followings',style: Theme.of(context).textTheme.caption,),


                          ]
                      ),
                    ),
                  ),
                ]
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        navigateTo(context, EditProfileScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Edit Profile',),
                          SizedBox(width: 30,),
                          Icon(Icons.edit,size: 16,)
                        ],
                      ),
                    )
                ),
                SizedBox(width: 10,),


                Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        navigateTo(context, SavePostsScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Posts Save',),
                          SizedBox(width: 20,),
                          Icon(Icons.bookmark_outline,size: 16,)
                        ],
                      ),
                    )
                ),

                SizedBox(width: 10,),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {

                    final choice = ChoiceDialog(
                      dialogBackgroundColor: Colors.white,
                      buttonCancelText: 'No',
                      buttonOkText: 'Yes',
                      buttonOkOnPressed: ()=>signOut(context),
                      title: 'Are you sure?',
                      message: 'Do you want to logout !',
                      buttonCancelOnPressed: () {
                        Navigator.pop(context);
                      },
                    );
                    choice.show(context);

                  },
                  child: Icon(Icons.exit_to_app,size: 20,color: Colors.white,),
                ),
              ]
            ),
          ),
          Divider(color: Colors.grey,height: 2,endIndent: 30,indent: 30,),
          SizedBox(height: 10,),
          ListView.separated(
            itemBuilder: (context, index) {
              print('cubit.postsForSettings.length ${cubit.postsForSettings.length}');

              commentController.add(new TextEditingController());
              return buildPostItem(
                postsForUser[index],
                context,
                index,
                commentController: commentController[index]??0,
                isSearch: false,



              );



            },
            itemCount: postsForUser.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 8),),



        ]
      ),
    );
  },
);
  }
}

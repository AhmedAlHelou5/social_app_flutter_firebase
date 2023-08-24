import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/modules/new_post/new_post_screen.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getPostsData();

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is HomeNewPostState)
          navigateTo(context, NewPostScreen());
      },
      builder: (context, state) {

        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_rounded),
                onPressed: () {

                }
              ),    IconButton(
                icon: Icon(Icons.search),
                onPressed: () {

                }
              ),
            ],


          ),
          body:cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,

            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items:cubit.bottomItems,
          ),

          // ConditionalBuilder(
          //   condition: HomeCubit.get(context).model != null,
          //   builder: (context) {
          //     var model = HomeCubit.get(context).model;
          //     return Column(
          //       children: [
          //         if (!FirebaseAuth.instance.currentUser!.emailVerified)
          //           Container(
          //             color: Colors.amber.withOpacity(0.6),
          //             height: 60,
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //               child: Row(children: [
          //                 Icon(Icons.info_outline),
          //                 SizedBox(width: 10),
          //                 Expanded(
          //                     flex: 3,
          //                     child: Text(
          //                       'please verify your email',
          //                       maxLines: 1,
          //                     )),
          //                 Spacer(),
          //                 defaultTextButton(
          //                   function: () {
          //                     FirebaseAuth.instance.currentUser!
          //                         .sendEmailVerification()
          //                         .then((value) {
          //                           showToast(text: 'check your email', state: ToastStates.SUCCESS);
          //                     })
          //                         .catchError((error) {});
          //                   },
          //                   text: 'Send',
          //                 )
          //               ]),
          //             ),
          //           )
          //       ],
          //     );
          //   },
          //   fallback: (BuildContext context) =>
          //       Center(child: CircularProgressIndicator()),
          // ),
        );
      },
    );
  }
}

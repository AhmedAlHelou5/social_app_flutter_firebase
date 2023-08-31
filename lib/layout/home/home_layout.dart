import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/modules/new_post/new_post_screen.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';

import '../../modules/search/search_screen.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
   HomeLayout({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var login = CacheHelper.getData(key: 'login');
    uId = CacheHelper.getData(key: 'uId');
    HomeCubit.get(context)
      ..getUserData()
      ..getAllUsers()
      ..getPostsData();

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is HomeNewPostState)
          navigateTo(context, NewPostScreen());

        // if(state is HomeGetAllUserLoadingState)
        //  HomeCubit.get(context).getAllUsers();

      },
      builder: (context, state) {

        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [

              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  navigateTo(context, SearchScreen());

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


        );
      },
    );
  }
}

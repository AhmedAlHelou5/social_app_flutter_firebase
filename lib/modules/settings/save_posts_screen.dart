
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/models/post/post_model.dart';
import 'package:social_app_flutter_firebase/shared/components/constants.dart';
import 'package:social_app_flutter_firebase/shared/styles/colors/colors.dart';
import 'package:intl/intl.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import '../../shared/components/components.dart';

class SavePostsScreen extends StatelessWidget {


  SavePostsScreen({Key? key}) : super(key: key);
  // var commentController = TextEditingController();
  List<TextEditingController> commentController = [];

  @override
  Widget build(BuildContext context) {
    // HomeCubit.get(context).getPostsById(userId);
    HomeCubit.get(context).getSavePost();


    return Builder(
        builder: (context) {

          print(' HomeCubit.get(context).postsSave.length ${HomeCubit.get(context).postSave.length}');
          return BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                // // TODO   if(state is HomeSavePostSuccessState ||state is HomeUnSavePostSuccessState ||state is HomeDeletePostSuccessState) {
                //                   HomeCubit.get(context).getSavePost();
                //                 }: implement listener

                  // HomeCubit.get(context).getSavePost();


              },
              builder: (context, state) {
                var cubit = HomeCubit.get(context);
                // print('cubit.savesPost.length ${cubit.savesPost!.length}');

                // cubit.getPostForUserSave();
                return Scaffold(
                  appBar: AppBar(
                    title: Text('save posts'),
                    centerTitle: true,
                  ),
                  body: ConditionalBuilder(
                    condition:   cubit.postSave.length > 0 ,
                    fallback: (BuildContext context) => Center(child: Text('No Posts Found'),),

                    builder:(BuildContext context) => SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child:  Column(
                        children: [

                          ListView.separated(
                            itemBuilder: (context, index) {
                              commentController.add(new TextEditingController());
                              return buildPostItem(
                                cubit.postSave[index],
                                context,
                                index,
                                commentController:  commentController[index] ,
                                // isSearch: true,
                                // isHome: true,


                              );

                            },
                            itemCount:  cubit.postSave!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (BuildContext context, int index) =>
                                SizedBox(height: 8),),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
    );

  }



}
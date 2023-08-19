import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';

import '../../layout/home/cubit/cubit.dart';
import '../edit_profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    // var cubit = HomeCubit.get(context);
    var model = HomeCubit.get(context).model;
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                     '${model.image}',
                    ),
                  ),
                )

              ]
            ),
          ),
          SizedBox(height: 5,),
          Text( '${model.name}',style: Theme.of(context).textTheme.bodyText1,),
          Text( '${model.bio}',style: Theme.of(context).textTheme.caption,),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text('100',style: Theme.of(context).textTheme.subtitle2,),
                        Text('posts',style: Theme.of(context).textTheme.caption,),


                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text('265',style: Theme.of(context).textTheme.subtitle2,),
                        Text('Photos',style: Theme.of(context).textTheme.caption,),


                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text('10k',style: Theme.of(context).textTheme.subtitle2,),
                        Text('Followers',style: Theme.of(context).textTheme.caption,),


                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text('64',style: Theme.of(context).textTheme.subtitle2,),
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
              Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('Add Photo',),
                  )
              ),
              SizedBox(width: 10,),
              OutlinedButton(
                onPressed: () {
                  navigateTo(context, EditProfileScreen());
                },
                child: Icon(Icons.edit,size: 16,),
              )
            ]
          )

        ]
      ),
    );
  },
);
  }
}

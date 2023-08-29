
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/modules/profile/view_profile.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import '../../models/user/user_model.dart';
import '../../shared/components/components.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        // var model = HomeCubit.get(context).model;

        return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildUserItem(cubit.users[index],context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: cubit.users.length);
      },
    );
  }

  Widget buildUserItem( modeluser,context) {

    return  InkWell(
      onTap: () {
        HomeCubit.get(context).getPostForUser(modeluser!.uId);
        navigateTo(context, ViewProfileScreen(model: modeluser));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                '${modeluser!.image}',
              )),
          SizedBox(width: 15),
          Text(
            '${modeluser.name}',
            style: TextStyle(height: 1.4),
          )
        ]),
      ),
    );
  }

}

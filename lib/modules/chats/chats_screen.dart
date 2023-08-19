import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import 'chat_details_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem(cubit.users[index],context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: cubit.users.length);
      },
    );
  }

  Widget buildChatItem(UserModel? model,context) =>
      InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(model: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  '${model!.image}',
                )),
            SizedBox(width: 15),
            Text(
              '${model!.name}',
              style: TextStyle(height: 1.4),
            )
          ]),
        ),
      );
}

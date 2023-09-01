// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:social_app_flutter_firebase/modules/profile/view_profile.dart';
//
// import '../../layout/home/cubit/cubit.dart';
// import '../../layout/home/cubit/states.dart';
// import '../../models/user/user_model.dart';
// import '../../shared/components/components.dart';
//
// class FollowersScreen extends StatelessWidget {
//   UserModel? model;
//
//   FollowersScreen(this.model);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeStates>(
//       listener: (context, state) {
//         // TODO: implement listener
//       },
//       builder: (context, state) {
//         var cubit = HomeCubit.get(context);
//         // var model = HomeCubit.get(context).model;
//
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Followers'),
//             centerTitle: true,
//           ),
//           body: ListView.separated(
//               physics: BouncingScrollPhysics(),
//               itemBuilder: (context, index) => buildUserItem(
//                   HomeCubit.get(context).followers, index,context),
//               separatorBuilder: (context, index) => myDivider(),
//               itemCount: HomeCubit.get(context).followers.length),
//         );
//       },
//     );
//   }
//
//   Widget buildUserItem(model, index, context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(children: [
//         CircleAvatar(
//             radius: 25,
//             backgroundImage: NetworkImage(
//               '${HomeCubit.get(context).followers[index]!.image}',
//             )),
//         SizedBox(width: 15),
//         Text(
//           '${HomeCubit.get(context).followers[index]!.name}',
//           style: TextStyle(height: 1.4),
//         )
//       ]),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
//
// class MenuItem {
//   const MenuItem({
//     required this.text,
//     required this.icon,
//   });
//
//   final String text;
//   final IconData icon;
// }
//
// abstract class MenuItems {
//   static const List<MenuItem> firstItems = [update, update, save];
//
//   static const update = MenuItem(text: 'edit post', icon: Icons.edit);
//   static const delete = MenuItem(text: 'delete post', icon: Icons.delete_forever);
//   static const save = MenuItem(text: 'save post', icon: Icons.bookmark_outline);
//
//   static Widget buildItem(MenuItem item) {
//     return Row(
//       children: [
//         Icon(item.icon, color: Colors.white, size: 22),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: Text(
//             item.text,
//             style: const TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   static void onChanged(BuildContext context, MenuItem item,{String? text,String? postId}) {
//     switch (item) {
//       case MenuItems.update:
//         // HomeCubit.get(context).updatePost(postId: postId, text: text);
//       //Do something
//         break;
//       case MenuItems.delete:
//         HomeCubit.get(context).deletePost(postId: postId,);
//
//         //Do something
//         break;
//       case MenuItems.save:
//       //Do something
//         break;
//
//     }
//   }
// }
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/shared/styles/colors/colors.dart';

import '../../shared/components/components.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel? model;

  ChatDetailsScreen({this.model});


  @override
  Widget build(BuildContext context) {
    return

      Builder(
          builder: (context) {
            HomeCubit.get(context).getMessages(recieverId: model!.uId);
            return BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                var cubit = HomeCubit.get(context);
                return Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, size: 16,),
                    ),
                    title: Row(
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                '${model!.image}',
                              )
                          ),
                          SizedBox(width: 15),
                          Text(
                            '${model!.name}',
                            style: TextStyle(fontSize: 16, height: 1.4),
                          )
                        ]
                    ),
                  ),
                  body: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Expanded(
                                  child: ConditionalBuilder(
                                    condition: cubit.messages.length > 0,

                                    builder: (context) => ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var message = cubit.messages[index];
                                          // buildMessage(cubit.messages[index]);

                                          if (cubit.messages[index].senderId == model!.uId)
                                            return buildMessage(message,context);

                                            return buildMyMessage(message,context);

                                          },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 15), itemCount: cubit.messages.length,

                                    ), fallback: (BuildContext context)=>Center(child: Text('No messages yet'),),

                                  ),
                                ),

                                if(cubit.messages.length == 0)
                                  Spacer(),
                                SizedBox(height: 20),

                                Container(
                                  // padding: EdgeInsets.all(5),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: defaultColor,
                                          width: 1

                                      ),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 15.0,),
                                              child: TextFormField(
                                                controller: cubit.messageController,
                                                decoration: InputDecoration(
                                                  hintText: 'Type your message',
                                                  border: InputBorder.none,
                                                ),
                                                // validator: (value){
                                                //   if(value!.length >0)
                                                //
                                                //   // cubit.messageController == value!;
                                                //
                                                // },
                                              ),
                                            )),

                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color: defaultColor,

                                          ),
                                          // color: defaultColor,
                                          child: MaterialButton(
                                            onPressed: () {
                                              if(cubit.messageController.text.isNotEmpty)
                                              cubit.sendMessage(
                                                text: cubit.messageController
                                                    .text,
                                                dateTime: DateTime.now()
                                                    .toString(),
                                                recieverId: model!.uId,
                                              );

                                              if(cubit.messageController.text.isEmpty){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('Message can\'t be empty'),
                                                ));
                                              }

                                            },
                                            minWidth: 1,
                                            child: Icon(
                                              Icons.send, color: Colors.white,
                                              size: 18,),

                                          ),
                                        )

                                      ]
                                  ),
                                ),

                              ]
                          ),
                        ),


                );
              },
            );
          }
      );
  }
}

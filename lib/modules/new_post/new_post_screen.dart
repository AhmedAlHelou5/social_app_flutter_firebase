import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors/colors.dart';

class NewPostScreen extends StatelessWidget {
   NewPostScreen({Key? key}) : super(key: key);
  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is HomeCreatePostSuccessState){
          // Navigator.pop(context);
          HomeCubit.get(context).getPostsData();


        }

      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var now = DateTime.now().toString();
        return Scaffold(
          appBar: defaultAppBar(
              context: context, title: 'Create Post', actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultTextButton(
                  function: () {

                    cubit.checkImageInPost(text:postController.text ,dateTime:now ,context: context);


                    // Navigator.of(context).pop();

                  },
                  text: 'Post'),
            ),
            SizedBox(
              width: 15,
            ),
          ]),

          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: [
                  if (state is HomeCreatePostLoadingState)
                  LinearProgressIndicator(),
                  if (state is HomeCreatePostLoadingState)
                    SizedBox(height: 10),
                  Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            '${cubit.model!.image}',),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            '${cubit.model!.name}',
                            style: TextStyle(height: 1.4, fontSize: 17),
                          ),
                        ),
                      ]
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: postController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: InputBorder.none
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Post must not be empty';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        postController.text = value.toString();
                      },
                      onSaved: (value){
                        postController.text = value.toString();
                      },


                    ),
                  ),
                  SizedBox(height: 20),
                  if (cubit.imagePostFile != null)
                  Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image: FileImage(cubit.imagePostFile!)
                                as ImageProvider,
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                            top: 10,
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            child: IconButton(
                                onPressed: () {
                                  cubit.removePostImage();
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 16,
                                )),
                          ),
                        )
                      ]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            cubit.getPostImageFromGallery();
                          }, child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 5,),
                            Text('Add Photo'),
                          ],
                        ),),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {}, child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text('# tags'),
                          ],
                        ),),
                      ),
                    ],
                  )


                ]
            ),
          ),

        );
      },
    );
  }
}

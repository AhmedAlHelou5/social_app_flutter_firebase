import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';

import '../../layout/home/cubit/states.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {

        var cubit = HomeCubit.get(context);
        var model = HomeCubit.get(context).model;
        var profileImage = HomeCubit.get(context).imageProfileFile;
        var coverImage = HomeCubit.get(context).imageCoverFile;
        var  nameController = TextEditingController();
        var phoneController = TextEditingController();
        var bioController = TextEditingController();
        nameController.text = model!.name!;
        phoneController.text = model.phone!;
        bioController.text = model.bio!;

        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Edit Profile', actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultTextButton(
                  function: () {
                    cubit.updateUser(
                        name: nameController.text.toString(),
                        phone: phoneController.text.toString(),
                        bio: bioController.text.toString());
                  },
                  text: 'Update'),
            ),
            SizedBox(
              width: 15,
            ),
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is HomeUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 180,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                        image: DecorationImage(
                                          image: coverImage == null
                                              ? NetworkImage(
                                                  '${model.cover}',
                                                )
                                              : FileImage(coverImage)
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
                                            cubit.getCoverFromGallery();
                                          },
                                          icon: Icon(
                                            Icons.camera_alt_rounded,
                                            size: 16,
                                          )),
                                    ),
                                  )
                                ]),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileImage == null
                                      ? NetworkImage(
                                          '${model.image}',
                                        )
                                      : FileImage(profileImage)
                                          as ImageProvider,
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                child: IconButton(
                                    onPressed: () {
                                      cubit.getProfileFromGallery();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                    )),
                              ),
                            ],
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (cubit.imageProfileFile != null ||
                      cubit.imageCoverFile != null)
                    Row(children: [
                      if (cubit.imageProfileFile != null)
                        Expanded(
                            child: Column(
                          children: [
                            defaultButton(
                                function: () {
                                  cubit.uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text);
                                },
                                text: 'Upload Profile Photo'),
                            if (state is HomeUserUpdateLoadingState)
                              SizedBox(
                                width: 5,
                              ),
                            if (state is HomeUserUpdateLoadingState)
                              LinearProgressIndicator(),
                          ],
                        )),
                      SizedBox(
                        width: 5,
                      ),
                      if (cubit.imageCoverFile != null)
                        Expanded(
                            child: Column(
                          children: [
                            defaultButton(
                                function: () {
                                  cubit.uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text);
                                },
                                text: 'Upload Cover Photo'),
                            if (state is HomeUserUpdateLoadingState)
                              SizedBox(
                                width: 5,
                              ),
                            if (state is HomeUserUpdateLoadingState)
                              LinearProgressIndicator(),
                          ],
                        )),
                    ]),
                  if (cubit.imageProfileFile != null ||
                      cubit.imageCoverFile != null)
                    SizedBox(
                      height: 20,
                    ),
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      onSubmit: (value) {
                        nameController.text = value.toString();
                      },
                      onSaved: (value){
                        nameController.text = value.toString();
                      },


                      label: 'Name',
                      prefix: Icons.person),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: bioController,
                      type: TextInputType.text,
                      maxLines: 3,
                      maxLength: 150,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'bio must not be empty';
                        }
                        return null;
                      },
                      onSaved: (value){
                        bioController.text = value.toString();
                      },
                      onSubmit: (value) {
                        bioController.text = value.toString();
                      },
                      label: 'bio',
                      prefix: Icons.info_outline),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.text,
                      maxLength: 10,
                      validate: (String? value) {
                        if (value!.isEmpty || value.length < 10) {
                          return 'phone must not be empty or length must be 10';
                        }
                        return null;
                      },
                      onSaved: (value){
                        phoneController.text = value.toString();
                      },
                      onSubmit: (value) {
                        phoneController.text = value.toString();
                      },
                      label: 'Phone',
                      prefix: Icons.phone),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

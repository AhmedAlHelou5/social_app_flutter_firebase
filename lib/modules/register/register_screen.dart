import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/home_layout.dart';
import 'package:social_app_flutter_firebase/modules/login/login_screen.dart';
import 'package:social_app_flutter_firebase/modules/register/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/modules/register/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is SocialCreateUserSuccessState) {
            navigateAndFinish(context, LoginScreen());

          }
          if (state is SocialRegisterSuccessState) {
            navigateAndFinish(context, LoginScreen());
          }

        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register'.toUpperCase(), style: Theme
                              .of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.black)),
                          SizedBox(height: 10),
                          Text('Register now to browse our hot offers',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.grey)),
                          SizedBox(height: 30),

                          defaultFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                              },
                              maxLines: 1,
                              label: 'User Name',
                              prefix: Icons.person),
                          SizedBox(height: 20),
                          defaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Email must not be empty and must contain @';
                                }
                              },
                              maxLines: 1,
                              label: 'Email',
                              prefix: Icons.email),
                          SizedBox(height: 20),

                          defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            maxLines: 1,
                            validate: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return 'Password must be at least 5 characters';
                              }
                            },
                            onSubmit: (value) {
                              // if (formKey.currentState!.validate()) {
                              //   SocialRegisterCubit.get(context).userLogin(
                              //       email: emailController.text,
                              //       password:passwordController.text);
                              // }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: SocialRegisterCubit
                                .get(context)
                                .suffix,
                            isPassword: SocialRegisterCubit
                                .get(context)
                                .isPassword,
                            suffixPresed: () {
                              SocialRegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },


                          ),
                          const SizedBox(height: 30),


                          defaultFormField(
                              controller: phoneController,
                              type: TextInputType.emailAddress,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone must not be empty ';
                                }
                              },
                              maxLines: 1,
                              label: 'Phone',
                              prefix: Icons.phone),
                          SizedBox(height: 20),


                          // 1 is! SocialRegisterLoadingState
                          ConditionalBuilder(
                            condition: state is! SocialRegisterLoadingState,
                            builder: (BuildContext context) =>
                                defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                          SocialRegisterCubit.get(context).userRegister(
                                              email: emailController.text,
                                              password:passwordController.text,
                                              name: nameController.text,
                                              phone: phoneController.text
                                          );
                                      }
                                    },
                                    text: 'Register',
                                    isUpperCase: true),
                            fallback: (BuildContext context) =>
                                Center(child: CircularProgressIndicator()),

                          ),
                          SizedBox(height: 15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?'),
                                defaultTextButton(
                                    function: () {
                                      navigateAndFinish(context, LoginScreen());
                                    },
                                    text: 'Login')
                              ]
                          )


                        ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

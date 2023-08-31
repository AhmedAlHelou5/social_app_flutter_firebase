import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/shared/network/local/cache_helper.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/home_layout.dart';
import '../../shared/components/components.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getPostsData();
    HomeCubit.get(context)
      ..getUserData()
      ..getPostsData();
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is SocialLoginErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessState) {
                HomeCubit.get(context).getPostsData();


            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, HomeLayout());
            });
            CacheHelper.saveData(key: 'login', value: true);

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
                            Text('Login'.toUpperCase(), style: Theme
                                .of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.black)),
                            SizedBox(height: 10),
                            Text('Login now to communicate with friends',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.grey)),
                            SizedBox(height: 30),

                            defaultFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                maxLines: 1,
                                validate: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Email must not be empty and must contain @';
                                  }
                                },
                                label: 'Email Address',
                                prefix: Icons.email_outlined),
                            SizedBox(height: 20),

                            defaultFormField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              validate: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Password must be at least 5 characters';
                                }
                              },
                              onSubmit: (value) {
                                if (formKey.currentState!.validate()) {

                                }
                              },
                              label: 'Password',
                              prefix: Icons.lock_outline,
                              maxLines: 1,
                              suffix: SocialLoginCubit.get(context).suffix,
                              isPassword: SocialLoginCubit.get(context).isPassword,
                              suffixPresed: () {
                                SocialLoginCubit.get(context).changePasswordVisibility();

                              },


                            ),
                            const SizedBox(height: 30),
                            ConditionalBuilder(
                              condition: 1 is! SocialLoginLoadingState,
                              builder: (BuildContext context) =>
                                  defaultButton(
                                      function: () {
                                        if (formKey.currentState!.validate()) {

                                          SocialLoginCubit.get(context).userLogin(
                                              email: emailController.text,
                                              password:passwordController.text);

                                        }

                                      },
                                      text: 'Login',
                                      isUpperCase: true),
                              fallback: (BuildContext context) =>
                                  Center(child: CircularProgressIndicator()),

                            ),
                            SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Don\'t have an account?'),
                                  defaultTextButton(
                                      function: () {
                                        navigateAndFinish(context, RegisterScreen());
                                      },
                                      text: 'register')
                                ]
                            )


                          ]),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}

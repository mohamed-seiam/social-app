// ignore_for_file: prefer_const_constructors


import 'package:chatapp/layout/social_home.dart';
import 'package:chatapp/modules/login/social_login_cubit/cubit.dart';
import 'package:chatapp/modules/login/social_login_cubit/states.dart';
import 'package:chatapp/modules/register/social_register_screen.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class SocialLoginScreen extends StatelessWidget {
   SocialLoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialloginState>(
        listener: (context,state)
        {
          if(state is SocialloginErrorState)
          {
            showToast(text: state.error,
                state:Toaststate.ERROR
            );
          }

          if(state is SocialloginSuccessState)
          {
            CachHelper.saveData(key:'uId' , value:state.uId).then((value)
            {
              navigateAndFinish(context, SocialHomeScreen());
            });

          }
        },
        builder: (context,state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image(
                        //   image:
                        //   AssetImage('assets/img/login.png'),
                        // ),
                        SizedBox(height: 10.0,),
                        Text(
                          "LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "login now to communicate with your friends",
                          style:
                          Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultformfield(
                          controller: EmailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "please entre your email address";
                            }
                          },
                          label: "Email Address",
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultformfield(
                          controller: PasswordController,
                          type: TextInputType.visiblePassword,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffix: SocialLoginCubit.get(context).isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          suufixpress: () => {
                            SocialLoginCubit.get(context)
                                .ChangePassowrdVisibality(),
                          },
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              SocialLoginCubit.get(context).userloin(
                                  email: EmailController.text,
                                  password: PasswordController.text);
                            }
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "password is too short ";
                            }
                          },
                          label: "Password",
                          icon: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialloginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userloin(
                                      email: EmailController.text,
                                      password: PasswordController.text);
                                }
                              },
                              text: 'Login',
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don\'t have an account?",
                            ),
                            defaultTextButton(
                              function: () {
                                navigteTo(context, SocialRegisterScreen());
                              },
                              text: 'register',
                            )
                          ],
                        ),
                      ],
                    ),
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

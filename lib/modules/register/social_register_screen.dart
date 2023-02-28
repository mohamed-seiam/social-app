// ignore_for_file: prefer_const_constructors

import 'package:chatapp/layout/social_home.dart';
import 'package:chatapp/modules/register/social_register_cubit/cubit.dart';
import 'package:chatapp/modules/register/social_register_cubit/states.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SocialRegisterScreen extends StatelessWidget {
  SocialRegisterScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  // ShopRegisterCubit cubit = new ShopRegisterCubit();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit,SocialregisterState>(
          listener: (context,state){
            if (state is SocialCreateUserSuccessState) {

                 navigateAndFinish(context,
                     SocialHomeScreen());
            }
          },
          builder: (context,state) {
            return  Scaffold(
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
                          Text(
                            "REGISTER",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Register now to communicate with your friends",
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          defaultformfield(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "please entre your name";
                              }
                            },
                            label: "User Name",
                            icon: Icons.person,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultformfield(
                            controller: EmailController,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "please entre your Email";
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
                            isPassword: SocialRegisterCubit
                                .get(context)
                                .isPassword,
                            suffix: SocialRegisterCubit
                                .get(context)
                                .isPassword ? Icons.visibility_outlined : Icons
                                .visibility_off_outlined,
                            suufixpress: () =>
                            {
                              SocialRegisterCubit.get(context)
                                  .ChangePassowrdVisibality(),
                            },
                            onSubmit: (value) {

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
                          defaultformfield(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "please entre your Phone Number";
                              }
                            },
                            label: "Phone Number",
                            icon: Icons.phone,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! SocialregisterLoadingState,
                            builder: (context) =>
                                defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        SocialRegisterCubit.get(context).userregister(
                                          name: nameController.text,
                                          email: EmailController.text,
                                          password: PasswordController.text,
                                          phone: phoneController.text,
                                        );
                                      }
                                    },
                                    text: 'Register',
                                    isUpperCase: true),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
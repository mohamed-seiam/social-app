import 'package:chatapp/layout/social_home.dart';
import 'package:chatapp/modules/register/social_register_cubit/cubit.dart';
import 'package:chatapp/modules/register/social_register_cubit/states.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterScreen extends StatefulWidget {
  const SocialRegisterScreen({super.key});

  @override
  State<SocialRegisterScreen> createState() => _SocialRegisterScreenState();
}

class _SocialRegisterScreenState extends State<SocialRegisterScreen> {
  var formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late TextEditingController nameController;

  late TextEditingController phoneController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialregisterState>(
          listener: (context, state) {
        if (state is SocialCreateUserSuccessState) {
          CachHelper.saveData(key: 'uId', value: state.uid);
          navigateAndFinish(context, const SocialHomeScreen());
        }
      }, builder: (context, state) {
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
                      Text(
                        "REGISTER",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Register now to communicate with your friends",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      defaultformfield(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "please entre your name";
                          }
                          return null;
                        },
                        label: "User Name",
                        icon: Icons.person,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultformfield(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "please entre your Email";
                          }
                          return null;
                        },
                        label: "Email Address",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultformfield(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        isPassword: SocialRegisterCubit.get(context).isPassword,
                        suffix: SocialRegisterCubit.get(context).isPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        suufixpress: () => {
                          SocialRegisterCubit.get(context)
                              .ChangePassowrdVisibality(),
                        },
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "password is too short ";
                          }
                          return null;
                        },
                        label: "Password",
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultformfield(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "please entre your Phone Number";
                          }
                          return null;
                        },
                        label: "Phone Number",
                        icon: Icons.phone,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! SocialregisterLoadingState,
                        builder: (context) => defaultButton(
                            function: () async {
                              if (formKey.currentState!.validate()) {
                              await  SocialRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'Register',
                            isUpperCase: true),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

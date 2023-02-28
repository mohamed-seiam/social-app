// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
   EditProfileScreen({Key? key}) : super(key: key);
  var bioController = TextEditingController();
  var nameController = TextEditingController();
   var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit = SocialCubit.get(context).model;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        bioController.text = cubit!.bio!;
        nameController.text = cubit.name!;
        phoneController.text = cubit.phone!;
        return  Scaffold(
          appBar: defaultAppbar(
            context: context,
            title: 'Edit Profile',
            actions:
            [
              defaultTextButton(
                function:()
                {
                  SocialCubit.get(context).upDateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                },
                text: 'Update',
              ),
              SizedBox(width: 15.0,),
            ],
          ),
          body:SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  if(state is SocialLoadingUpdateDataState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 140.0,
                                decoration: BoxDecoration
                                  (
                                  borderRadius:BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage ==null ? NetworkImage('${cubit.cover}'):FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed:(){
                                    SocialCubit.get(context).upLoadCoverImage();
                                  },
                                  icon:CircleAvatar(
                                    radius: 20,
                                    child: Icon(Icons.camera_alt_outlined,
                                      size: 18.0,
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: SocialCubit.get(context).profileImage == null ? NetworkImage('${cubit.image}'):FileImage(profileImage!)as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed:(){
                                SocialCubit.get(context).upLoadImage();
                              },
                              icon:CircleAvatar(
                                radius: 18,
                                child: Icon(Icons.camera_alt_outlined,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  if(SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                    Row(
                      children: [
                        if(SocialCubit.get(context).profileImage!=null)
                          Expanded(
                           child: Column(
                             children: [
                               defaultButton(
                                  function:(){
                                    SocialCubit.get(context).saveProfileImageToDataBase(
                                        name:nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                    );
                                  },
                                  text:'up load profile',
                          ),
                               if(state is SocialLoadingUpdateDataState)
                               SizedBox(height: 5.0,),
                               if(state is SocialLoadingUpdateDataState)
                               LinearProgressIndicator(),
                             ],
                           ),
                        ),
                        SizedBox(width: 8.0,),
                        if(SocialCubit.get(context).coverImage!=null)

                          Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                function:(){
                                  SocialCubit.get(context).saveCoverImageToDataBase(
                                    name:nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                },
                                text:'up load cover',
                              ),
                              if(state is SocialLoadingUpdateDataState)
                              SizedBox(height: 5.0,),
                              if(state is SocialLoadingUpdateDataState)
                              LinearProgressIndicator(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if(SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                  SizedBox(height: 20.0,),
                  defaultformfield(
                      controller:bioController ,
                      type: TextInputType.text,
                      label: 'bio',
                      validate:( value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'bio must not be empty';
                        }
                        else
                        {
                          return '';
                        }
                      },
                      icon:
                          Icons.info_outlined,
                  ),
                  SizedBox(height: 20.0,),
                  defaultformfield(
                    controller:nameController,
                    type: TextInputType.name,
                    label: 'Name',
                    validate:( value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'Name must not be empty';
                      }
                      else
                      {
                        return '';
                      }
                    },
                    icon:
                    Icons.person,
                  ),
                  SizedBox(height: 20.0,),
                  defaultformfield(
                    controller:phoneController ,
                    type: TextInputType.phone,
                    label: 'Phone number',
                    validate:( value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'phone number must not be empty';
                      }
                      else
                      {
                        return '';
                      }
                    },
                    icon:
                    Icons.call,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

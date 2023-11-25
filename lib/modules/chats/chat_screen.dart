import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/modules/chats/widgets/chat_user_card.dart';
import 'package:chatapp/network/remote/apis.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/states.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Api.user != null) {
        if (message.toString().contains('resume')) {
          Api.updateActiveStatus(isOnline: true,);
        }
        if (message.toString().contains('pause')) {
          Api.updateActiveStatus(isOnline: false,);
        }
      }
      return Future.value(message);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).allUsers.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatUserCard(
                socialUserModel: SocialCubit.get(context).allUsers[index],
              );
            },
            separatorBuilder: (context, index) => mydivider(),
            itemCount: SocialCubit.get(context).allUsers.length,
          ),
          fallback: (context) => SocialCubit.get(context).allUsers.isEmpty
              ? const Center(child: Text('there is no users yet'))
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

// Widget buildChatItem(SocialUserModel socialUserModel, context) => InkWell(
//       onTap: () {
//         navigteTo(
//           context,
//           ChatDetailsScreen(
//             userModel: socialUserModel,
//           ),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         elevation: 2,
//         color: Colors.white60.withOpacity(.5),
//         child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10.0),
//             child: ListTile(
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                       MediaQuery.of(context).size.height * .3),
//                   child: CachedNetworkImage(
//                     width: MediaQuery.of(context).size.height * .065,
//                     height: MediaQuery.of(context).size.height * .065,
//                     imageUrl: socialUserModel.image,
//                     placeholder: (context, url) =>
//                         const CircularProgressIndicator(),
//                     fit: BoxFit.fill,
//                     placeholderFadeInDuration:
//                         const Duration(milliseconds: 400),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error_outlined),
//                   ),
//                 ),
//                 title: Text(
//                   socialUserModel.name,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, height: 1.4),
//                 ),
//                 subtitle: Text(SocialCubit.get(context).lastMessage ??
//                     'hello iam using this chat'),
//                 trailing: Container(
//                   width: 15,
//                   height: 15,
//                   decoration: BoxDecoration(
//                       color: Colors.greenAccent.shade400,
//                       borderRadius: BorderRadius.circular(10)),
//                 ))),
//       ),
//     );
}

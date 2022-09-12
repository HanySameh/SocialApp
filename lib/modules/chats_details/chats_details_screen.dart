import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/message_model.dart';
import '../../models/social_user_model.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

class ChatsDetailsScreen extends StatelessWidget {
  SocialUserModel? userModel;
  ChatsDetailsScreen({Key? key, this.userModel}) : super(key: key);
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel!.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (SocialCubit.get(context).messages.isNotEmpty) {
              scrollController.jumpTo(
                scrollController.position.maxScrollExtent,
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage('${userModel!.image}'),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text('${userModel!.name}'),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (SocialCubit.get(context).messages.isEmpty)
                      Text('Start Chat with ${userModel!.name}'),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message =
                              SocialCubit.get(context).messages[index];
                          if (SocialCubit.get(context).userModel!.uId ==
                              message.senderId) {
                            return buildMyMessage(message, context);
                          }
                          return buildMessage(message, context);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15.0,
                        ),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if (SocialCubit.get(context).chatImage != null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                  image: FileImage(
                                      SocialCubit.get(context).chatImage),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              SocialCubit.get(context).removeChatImage();
                            },
                            icon: const CircleAvatar(
                              radius: 15.0,
                              child: Icon(
                                Icons.close,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (SocialCubit.get(context).chatImage != null)
                      const SizedBox(
                        height: 15.0,
                      ),
                    if (state is SocialSendMessagesLoadingState)
                      const LinearProgressIndicator(),
                    if (state is SocialSendMessagesLoadingState)
                      const SizedBox(
                        height: 15.0,
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: defaultColor,
                                ),
                                borderRadius: BorderRadius.circular(100.0)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'write your message here....',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getChatImage();
                                  },
                                  icon: const Icon(
                                    Icons.image,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        IconButton(
                          onPressed: () {
                            if (messageController.text != '' &&
                                SocialCubit.get(context).chatImage == null) {
                              SocialCubit.get(context).sendMessages(
                                receiverId: userModel!.uId,
                                dateTime: DateFormat().format(DateTime.now()),
                                text: messageController.text,
                              );
                            } else {
                              if (SocialCubit.get(context).chatImage != null) {
                                SocialCubit.get(context).uploadChatImage(
                                  dateTime: DateFormat().format(DateTime.now()),
                                  text: messageController.text,
                                  receiverId: userModel!.uId,
                                );
                              }
                              SocialCubit.get(context).chatImage = null;
                            }
                            messageController.text = '';
                            scrollController.jumpTo(
                              scrollController.position.maxScrollExtent,
                            );
                          },
                          padding: EdgeInsets.zero,
                          icon: const CircleAvatar(
                            radius: 35.0,
                            child: Icon(
                              IconBroken.Send,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // CircleAvatar(
            //   radius: 20.0,
            //   backgroundImage: NetworkImage('${userModel!.image}'),
            // ),
            // SizedBox(
            //   width: 5.0,
            // ),
            Container(
              width: 200.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  bottomEnd: Radius.circular(10.0),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.chatImage != '')
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            image: NetworkImage('${model.chatImage}'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  if (model.chatImage != '')
                    const SizedBox(
                      height: 5.0,
                    ),
                  Text(
                    '${model.text}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model.dateTime}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildMyMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 200.0,
              decoration: BoxDecoration(
                color: defaultColor.withOpacity(0.2),
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(10.0),
                  topEnd: Radius.circular(10.0),
                  bottomStart: Radius.circular(10.0),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text(
                  //   '${SocialCubit.get(context).userModel!.name}',
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // if (model.chatImage !='')
                  //   SizedBox(
                  //     height: 5.0,
                  //   ),
                  if (model.chatImage != '')
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            image: NetworkImage('${model.chatImage}'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  if (model.chatImage != '')
                    const SizedBox(
                      height: 5.0,
                    ),
                  Text(
                    '${model.text}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model.dateTime}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: 5.0,
            // ),
            // CircleAvatar(
            //   radius: 20.0,
            //   backgroundImage: NetworkImage('${SocialCubit.get(context).userModel!.image}'),
            // ),
          ],
        ),
      );
}

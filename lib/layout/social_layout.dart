import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/new_post/new_post_screen.dart';
import '../modules/social_login/social_login_screen.dart';
import '../shared/components/component.dart';
import '../shared/network/local/cache_helper.dart';
import '../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Notification,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Search,
                ),
              ),
              IconButton(
                onPressed: () {
                  CacheHelper.removeData(
                    key: 'uId',
                  ).then((value) {
                    if (value) {
                      navigateAndFinish(context, SocialLoginScreen());
                    }
                  });
                },
                icon: const Icon(
                  IconBroken.Logout,
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Upload,
                ),
                label: 'New Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.User,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
          body: cubit.socialScreens[cubit.currentIndex],
        );
      },
    );
  }
}



// var model =SocialCubit.get(context).model;
// if (model!.isEmailVerified==false)
// Container(
//   color: Colors.amber.withOpacity(.6),
//   child: Padding(
//     padding:  EdgeInsets.symmetric(
//       horizontal: 20.0,
//     ),
//     child: Row(
//       children: [
//         Icon(
//             Icons.info_outline
//         ),
//         SizedBox(
//           width: 15.0,
//         ),
//         Expanded(
//           child: Text(
//             'Please verify your email',
//             style: TextStyle(
//               color: Colors.black,
//             ),
//
//           ),
//         ),
//         SizedBox(
//           width: 15.0,
//         ),
//         defaultTextButton(
//             function: (){},
//             text: 'send'
//         ),
//       ],
//     ),
//   ),
// ),
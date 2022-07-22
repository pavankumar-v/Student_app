import 'dart:async';

import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/main/pages/attendanceView.dart';
import 'package:brindavan_student/view/main/pages/dynamicForms.dart';
import 'package:brindavan_student/view/main/pages/starredNotification.dart';
import 'package:brindavan_student/view/main/wiget/recent_notification.dart';

import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../theme/theme_provider.dart';
import 'demo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _timeString;
  Timer? timer;

  bool loading = false;

  // late User user;
  String? avatar;
  Stream<UserData>? data;
  Future<Subjects?>? subjectList;
  DataProvider? dataProvider;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    data = dataProvider.userData;
    _getTime();
    timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('home called');;
    final MyColor = Theme.of(context).extension<MyColors>()!;
    return loading
        ? const Loading()
        : StreamBuilder<UserData?>(
            stream: data,
            builder: (context, snapshot) {
              UserData? userData = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: AppBar(
                    elevation: 0,
                    title: Row(children: [
                      CircleAvatar(
                        backgroundColor: Colors.black12,
                        backgroundImage:
                            CachedNetworkImageProvider(userData!.avatar),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userData.fullName.text.lg.bold.make(),
                            userData.usn.text.uppercase.base.make(),
                          ]),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.menu), // set your color here
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      )
                    ]),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: MediaQuery.of(context).size.height * 0.2,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(11),
                        //       image: DecorationImage(
                        //         image: const CachedNetworkImageProvider(
                        //             'https://firebasestorage.googleapis.com/v0/b/brindavan-student-app.appspot.com/o/assets%2Fdrawer_bg%2Fteacher.jpg?alt=media&token=6e8780c9-0269-4203-b176-41047ef6bbdc'),
                        //         fit: BoxFit.cover,
                        //         colorFilter: ColorFilter.mode(
                        //             Colors.black.withOpacity(0.3),
                        //             BlendMode.darken),
                        //       )),
                        //   child: _timeString!.text.bold
                        //       .letterSpacing(3)
                        //       .white
                        //       .xl5
                        //       .make()
                        //       .p(25),
                        // ).py(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Quick Access".text.bold.lg.make(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ICON 1
                                Column(
                                  children: [
                                    // ICON 1
                                    IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const StarredNotification()));
                                            },
                                            icon: const Icon(
                                                Icons.bookmark_added))
                                        .card
                                        .rounded
                                        .color(Theme.of(context)
                                            .colorScheme
                                            .primary)
                                        .make(),
                                    "Saved Notifications"
                                        .text
                                        .sm
                                        .center
                                        .make()
                                        .py(6)
                                        .w20(context)
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    // ICON 1
                                    IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AvatarList()));
                                            },
                                            icon: const Icon(
                                                Icons.account_circle))
                                        .card
                                        .rounded
                                        .color(Theme.of(context)
                                            .colorScheme
                                            .primary)
                                        .make(),
                                    "Change Avatar"
                                        .text
                                        .sm
                                        .center
                                        .make()
                                        .py(6)
                                        .w20(context)
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    // ICON 1
                                    IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DynamicForms()));
                                            },
                                            icon: const Icon(
                                                Icons.description_rounded))
                                        .card
                                        .rounded
                                        .color(Theme.of(context)
                                            .colorScheme
                                            .primary)
                                        .make(),
                                    "Fill Survey Forms"
                                        .text
                                        .sm
                                        .center
                                        .make()
                                        .py(6)
                                        .w20(context)
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    // ICON 1
                                    IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Attendance(
                                                            userData: userData,
                                                          )));
                                            },
                                            icon: const Icon(
                                                Icons.event_available_rounded))
                                        .card
                                        .rounded
                                        .color(Theme.of(context)
                                            .colorScheme
                                            .primary)
                                        .make(),
                                    "Check Attendance"
                                        .text
                                        .sm
                                        .center
                                        .make()
                                        .py(6)
                                        .w20(context)
                                  ],
                                )
                              ],
                            ).pOnly(top: 22)
                          ],
                        )
                            .p(14)
                            .card
                            .rounded
                            .elevation(1)
                            .make()
                            .p(0)
                            .pOnly(top: 16),
                        'Recent'.text.xl4.bold.make().py12(),
                        const RecentNotification(),
                      ],
                    ).px(12),
                  ),
                );
              } else {
                return const Loading();
              }
            });
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('h:mma\ndd/MM/yyyy').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
  }
}

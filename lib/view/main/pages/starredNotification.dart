// ignore_for_file: unrelated_type_equality_checks

import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/view/main/pages/static/read_more_notification.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../services/database.dart';

class StarredNotification extends StatefulWidget {
  const StarredNotification({Key? key}) : super(key: key);

  @override
  State<StarredNotification> createState() => _StarredNotificationState();
}

class _StarredNotificationState extends State<StarredNotification> {
  var userData;
  @override
  void initState() {
    // This is the type used by the popup menu below.
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    userData = dataProvider.userData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: "Starred Notifications".text.make(),
        actions: const [
          // IconButton(
          //     onPressed: () {
          //       TestService().fooUsers();
          //     },
          //     icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<UserData?>(
        stream: userData,
        builder: (context, snapshot) {
          UserData? user = snapshot.data;
          // print(user!.starredNotifications!.reversed);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return "Something went wrong".text.make();
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            // print(user!.starredNotifications!.length);/

            if (user!.starredNotifications!.isEmpty) {
              return Center(
                child: "Empty"
                    .text
                    .bold
                    .xl5
                    .color(Theme.of(context).hintColor)
                    .make(),
              );
            } else {
              for (var i = 0; i < user.starredNotifications!.length / 2; i++) {
                var temp = user.starredNotifications![i];
                user.starredNotifications![i] = user.starredNotifications![
                    user.starredNotifications!.length - 1 - i];
                user.starredNotifications![
                    user.starredNotifications!.length - 1 - i] = temp;
              }
              return ListView.builder(

                  // shrinkWrap: true,

                  physics: const BouncingScrollPhysics(),
                  itemCount: user.starredNotifications!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        Future<dynamic>? res = DatabaseService()
                            .getStarredNotifications(
                                user.starredNotifications![index].id,
                                user.starredNotifications![index].department);
                        var result = await res;
                        NotificationData? data = NotificationData(
                            id: "",
                            fullName: result["fullName"],
                            position: result["position"],
                            title: result["title"],
                            description: result["description"],
                            createdAt: result["createdAt"],
                            avatar: result["avatar"],
                            tags: result["tags"],
                            department: result["department"]);
                        // print(data.fullName);
                        // print(result);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReadMoreNotification(
                                  notification: data,
                                )));
                      },
                      trailing: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          // splashRadius: 30,

                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          splashRadius: 23,
                          icon: const Icon(Icons.bookmark),
                          tooltip: 'star notification',
                          onPressed: () {
                            DatabaseService().removeFromStared(
                              user.starredNotifications![index].id,
                              user.starredNotifications![index].fullName,
                              user.starredNotifications![index].title,
                              user.starredNotifications![index].department,
                            );
                            SnackBar snackBar = SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              dismissDirection: DismissDirection.down,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              content: "removed"
                                  .text
                                  .color(
                                      Theme.of(context).colorScheme.background)
                                  .make(),
                              action: SnackBarAction(
                                label: 'Undo',
                                textColor:
                                    Theme.of(context).colorScheme.primary,
                                onPressed: () {
                                  DatabaseService().starNotification(
                                      user.starredNotifications![index].id,
                                      user.starredNotifications![index]
                                          .fullName,
                                      user.starredNotifications![index].title,
                                      user.starredNotifications![index]
                                          .department);
                                },
                              ),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ),
                      ),
                      title: user.starredNotifications![index].fullName!.text
                          .color(
                              Theme.of(context).colorScheme.onPrimaryContainer)
                          .lg
                          .bold
                          .make(),
                      subtitle: user
                                  .starredNotifications![index].title!.length >
                              28
                          ? "${user.starredNotifications![index].title!.substring(0, 27)} •••"
                              .text
                              .color(Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)
                              .capitalize
                              .make()
                          : user.starredNotifications![index].title!.text
                              .color(Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)
                              .capitalize
                              .make(),
                    )
                        .card
                        .rounded
                        .color(Theme.of(context).colorScheme.primaryContainer)
                        .make()
                        .py(5);
                  });
            }
          } else {
            return Center(
              child: "Nothing Starred".text.black.bold.lg.make(),
            );
          }
        },
      ).p(12),
    );
  }
}

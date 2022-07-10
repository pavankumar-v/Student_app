import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../reusable_widget/notification_card_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class RecentNotification extends StatefulWidget {
  const RecentNotification({Key? key}) : super(key: key);

  @override
  State<RecentNotification> createState() => _RecentNotificationState();
}

class _RecentNotificationState extends State<RecentNotification> {
  Stream<List<NotificationData?>?>? notificationData;
  var userData;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    notificationData = dataProvider.notificationBySection;
    userData = dataProvider.userData;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData?>(
        stream: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          UserData? user = snapshot.data!;
          List<StarredPostData>? listCheck = (user.starredNotifications!);
          return StreamBuilder<List<NotificationData?>?>(
              stream: notificationData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length > 1 ? 2 : 1,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          bool contain = false;
                          for (var element in listCheck) {
                            if (element.id == snapshot.data![index]!.id) {
                              contain = true;
                              break;
                            }
                          }
                          return NotificationWidget(
                            notification: data,
                            isContain: contain,
                          ); // passing into widget constructor
                        });
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: "No Posts".text.bold.xl5.make(),
                    );
                  }
                  {
                    return Center(
                      child: "No Recent Posts".text.make(),
                    );
                  }
                } else {
                  return const Loading();
                }
              });
        });
  }
}

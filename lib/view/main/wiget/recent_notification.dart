import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../reusable_widget/notification_card_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class RecentNotification extends StatefulWidget {
  const RecentNotification({Key? key}) : super(key: key);

  @override
  State<RecentNotification> createState() => _RecentNotificationState();
}

class _RecentNotificationState extends State<RecentNotification> {
  Stream<List<NotificationData?>?>? notificationData;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    notificationData = dataProvider.notificationBySection;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationData?>?>(
        stream: notificationData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 2) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return NotificationWidget(
                        notification: data); // passing into widget constructor
                  });
            } else {
              return Center(
                child: "No Recent Posts".text.make(),
              );
            }
          } else {
            return const Loading();
          }
        });
  }
}

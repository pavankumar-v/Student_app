import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/theme/theme_provider.dart';
import 'package:brindavan_student/view/main/reusable_widget/notification_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool loading = false;
  Stream<List<NotificationData?>?>? notificationDataAll;
  Stream<List<NotificationData?>?>? notificationDataBySection;
  Stream<List<NotificationData?>?>? notificationDataByBranch;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    notificationDataAll = dataProvider.notificationAll;
    notificationDataBySection = dataProvider.notificationBySection;
    notificationDataByBranch = dataProvider.notificationByBranch;
    // _notificationData = _dataProvider.notifications;

    super.initState();
  }

  @override
  void dispose() {
    // _dataProvider!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var MyColor = Theme.of(context).extension<MyColors>()!;

    return loading
        ? const Loading()
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                elevation: 0,
                title: 'Notification'.text.xl3.bold.center.make(),
                bottom: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      Tab(
                          child: Text('Class',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.textColor))),
                      Tab(
                          child: Text('Branch',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.textColor))),
                      Tab(
                          child: Text('College',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.textColor))),
                    ]),
              ),
              body: TabBarView(children: [
                Center(
                  child: StreamBuilder<List<NotificationData?>?>(
                      stream: notificationDataBySection,
                      builder: (context, snapshot) {
                        // print(snapshot.data!.length);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.active &&
                            snapshot.hasData) {
                          return ListView.builder(
                              addAutomaticKeepAlives: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data![index];
                                return NotificationWidget(notification: data)
                                    .px(20); // passing into widget constructor
                              });
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: "No Posts".text.bold.xl5.make(),
                          );
                        } else {
                          return Center(
                            child: "Noting Found"
                                .text
                                .lg
                                .bold
                                .color(Theme.of(context).hintColor)
                                .make(),
                          );
                        }
                      }),
                ),
                Center(
                  child: StreamBuilder<List<NotificationData?>?>(
                      stream: notificationDataByBranch,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                              addAutomaticKeepAlives: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data![index];
                                return NotificationWidget(notification: data)
                                    .px(20); // passing into widget constructor
                              });
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: "No Posts".text.bold.xl5.make(),
                          );
                        } else {
                          return Center(
                            child: "Noting Found"
                                .text
                                .lg
                                .bold
                                .color(Theme.of(context).hintColor)
                                .make(),
                          );
                        }
                      }),
                ),
                Center(
                  child: StreamBuilder<List<NotificationData?>?>(
                      stream: notificationDataAll,
                      builder: (context, snapshot) {
                        // print(snapshot.data![0]!.fullName);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                              addAutomaticKeepAlives: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data![index];
                                return NotificationWidget(notification: data)
                                    .px(20); // passing into widget constructor
                              });
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: "No Posts".text.bold.xl5.make(),
                          );
                        } else {
                          return Center(
                            child: "Noting Found"
                                .text
                                .lg
                                .bold
                                .color(Theme.of(context).hintColor)
                                .make(),
                          );
                        }
                      }),
                ),
              ]),
            ),
          );
  }
}

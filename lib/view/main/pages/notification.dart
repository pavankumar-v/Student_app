import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/provider/data_provider.dart';
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
  Stream<List<NotificationData?>?>? notificationData;

  @override
  void initState() {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    notificationData = dataProvider.notifications;

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
    final dataProvider = Provider.of<DataProvider>(context);

    return loading
        ? const Loading()
        : DefaultTabController(
          length: 3,
          child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                  elevation: 0, title: 'Notification'.text.xl3.bold.center.make(),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child:Text('Class',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))),
                      Tab(
                        child:Text('HOD',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))),
                      Tab(
                        child:Text('College',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))),

                    ] ),),
              body: TabBarView(
                children: [
                  Center(child: Text('Tab 1 Content')),
                  Center(child: Text('Tab 2  Content')),
                  Center(
                    child: StreamBuilder<List<NotificationData?>?>(
                  stream: notificationData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          addAutomaticKeepAlives: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data![index];
                            return NotificationWidget(notification: data)
                                .px(20); // passing into widget constructor
                          });
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
                  }
                 ), ),
              ]),  
                ),
        );
  }
}

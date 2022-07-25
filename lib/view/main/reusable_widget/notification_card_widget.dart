import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/view/main/pages/static/read_more_notification.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../theme/theme_provider.dart';

class NotificationWidget extends StatefulWidget {
  final NotificationData? notification;
  bool? isContain;
  NotificationWidget(
      {Key? key, required this.notification, required this.isContain})
      : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    var MyColor = Theme.of(context).extension<MyColors>()!;
    var data = widget.notification;
    // if(widget.isContain == null){
    //   widget.isContain = false;
    // }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReadMoreNotification(
                  notification: data,
                )));
      },
      child: Container(
        // decoration: BoxDecoration(
        //   color: Theme.of(context).canvasColor,
        //   borderRadius: BorderRadius.circular(16),
        //   // border: Border.all(
        //   //   color: Colors.grey.shade700,
        //   // )
        // ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: data!.position == "Admin"
                        ? Vx.hexToColor('#00A47A')
                        : data.position == "hod"
                            ? Vx.hexToColor('#FFBA24')
                            : Vx.hexToColor('#0057D0'),
                    child:
                        data.fullName[0].text.bold.color(Colors.white).make(),
                    // backgroundImage: NetworkImage(data!.avatar),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data.fullName.text.bold.make(),
                        Row(
                          children: [
                            (timeago.format(data.createdAt.toDate()!))
                                .text
                                .sm
                                .color(Theme.of(context).hintColor)
                                .lineHeight(1.5)
                                .make()
                          ],
                        )
                      ]).pOnly(left: 12),
                  const Spacer(),
                  IconButton(
                    // splashRadius: 30,

                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    splashRadius: 23,
                    // splashColor: Theme.of(context).colorScheme.background,

                    icon: widget.isContain!
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_outline),
                    tooltip: 'star notification',
                    onPressed: () {
                      if (widget.isContain!) {
                        DatabaseService().removeFromStared(data.id,
                            data.fullName, data.title, data.department);
                      } else {
                        DatabaseService().starNotification(data.id,
                            data.fullName, data.title, data.department);
                      }

                      SnackBar snackBar = SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                        dismissDirection: DismissDirection.down,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: (widget.isContain!
                                ? "Removed"
                                : "Notification Saved")
                            .text
                            .color(Theme.of(context).colorScheme.background)
                            .make(),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            if (widget.isContain!) {
                              DatabaseService().removeFromStared(data.id,
                                  data.fullName, data.title, data.department);
                            } else {
                              DatabaseService().starNotification(data.id,
                                  data.fullName, data.title, data.department);
                            }
                          },
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  )
                      .card
                      .roundedLg
                      .elevation(0)
                      .make()
                      .backgroundColor(Colors.transparent),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SelectableText(
                data.title,
                style: const TextStyle(
                    height: 1.5, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // data.title.text.lg.bold.make(),
              const SizedBox(
                height: 10,
              ),
              // RichText(
              //   text: TextSpan(
              //     children: <TextSpan>[
              //       TextSpan(
              //         text: data.description.length > 100
              //             ? "${data.description.substring(0, 99)}  •••"
              //             : data.description, // emoji characters
              //         style: TextStyle(
              //           color: Theme.of(context).colorScheme.onBackground,
              //           fontFamily: 'EmojiOne',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              data.description.length > 100
                  ? ("${data.description.substring(0, 99)}  •••"
                      .text
                      .base
                      .lineHeight(1.5)
                      .make())
                  : data.description.text.lineHeight(1.5).make(),

              Row(
                children: [
                  for (var i = 0;
                      i < (data.tags.length > 3 ? 3 : data.tags.length);
                      i++)
                    "#${data.tags[i]}"
                        .text
                        .color(Colors.blue)
                        .make()
                        .pLTRB(0, 0, 5, 0),
                ],
              ).py(5),
            ],
          ).p(23),
        ]),
      ).card.rounded.elevation(1).make().py(5).px(0),
    );
  }
}

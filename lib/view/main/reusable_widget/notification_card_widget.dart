import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/view/main/pages/static/read_more_notification.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../theme/theme_provider.dart';

class NotificationWidget extends StatefulWidget {
  final NotificationData? notification;
  const NotificationWidget({Key? key, required this.notification})
      : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    var MyColor = Theme.of(context).extension<MyColors>()!;
    var data = widget.notification;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReadMoreNotification(
                  notification: data,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(
          //   color: Colors.grey.shade700,
          // )
        ),
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
                  Material(
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.background,
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        // splashRadius: 30,

                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        splashRadius: 23,
                        // splashColor: Theme.of(context).colorScheme.background,
                        icon: const Icon(Icons.grade_outlined),
                        tooltip: 'star notification',
                        onPressed: () {
                          DatabaseService().starNotification(
                              data.id, data.fullName, data.title);
                          SnackBar snackBar = SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.onBackground,
                            dismissDirection: DismissDirection.down,
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            content: "Notification Starred"
                                .text
                                .color(Theme.of(context).colorScheme.background)
                                .make(),
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                DatabaseService().removeFromStared(
                                    data.id, data.fullName, data.title);
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      ),
                    ),
                  ),
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
              data.description.length > 100
                  ? (data.description
                      .substring(0, 99)
                      .text
                      .lineHeight(1.5)
                      .make())
                  : data.description.text.lineHeight(1.5).make(),

              // SelectableLinkify(
              //   // text: data.description,
              //   text: data.description.length > 250
              //       ? "${data.description.substring(0, 249)} ........"
              //       // ? "${data.description.substring(0, ((data.description.length / 100) * 85).floor())} ........"
              //       : data.description,
              //   onOpen: (link) async {
              //     final Uri url = Uri.parse(link.url);

              //     Future<void> _launchInBrowser(Uri url) async {
              //       if (!await launchUrl(
              //         url,
              //         mode: LaunchMode.externalApplication,
              //       )) {
              //         throw 'Could not launch $url';
              //       }
              //     }

              //     await _launchInBrowser(url);
              //   },
              //   options: const LinkifyOptions(humanize: false),
              //   style: const TextStyle(height: 1.5, fontSize: 14),
              // ),

              Row(
                children: [
                  for (var i in data.tags)
                    "#$i".text.color(Colors.blue).make().pLTRB(0, 0, 5, 0),
                ],
              ).py(5),

              // data.description.text.lineHeight(1.5).sm.make(),
            ],
          ).p(23),
        ]),
      ).py12(),
    );
  }

  // _chipBuilder(tags){
  //   return Row(

  //   )
  // }
}

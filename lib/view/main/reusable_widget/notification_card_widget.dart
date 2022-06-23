import 'package:brindavan_student/models/notificationdata.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationWidget extends StatefulWidget {
  final NotificationData? notification;
  const NotificationWidget({Key? key, required this.notification})
      : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.notification;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: Colors.grey.shade700,
          )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(data!.avatar),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  data.fullName.text.bold.make(),
                  Row(
                    children: [
                      data.position.text.uppercase.lineHeight(1.5).sm.make(),
                      (formatDate(DateTime.parse(data.createdAt),
                              [MM, ' ', d, ', ', yyyy]))
                          .text
                          .lineHeight(1.5)
                          .sm
                          .italic
                          .color(Theme.of(context).hintColor)
                          .make()
                          .pLTRB(6, 0, 0, 0)
                    ],
                  )
                ]).pOnly(left: 12),
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

            SelectableLinkify(
              text: data.description,
              onOpen: (link) async {
                final Uri url = Uri.parse(link.url);

                Future<void> _launchInBrowser(Uri url) async {
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw 'Could not launch $url';
                  }
                }

                await _launchInBrowser(url);
              },
              options: const LinkifyOptions(humanize: false),
              style: const TextStyle(height: 1.5, fontSize: 12),
            ),

            "${data.tags}".text.make()
            // data.description.text.lineHeight(1.5).sm.make(),
          ],
        ).p(23),
      ]),
    ).py12();
  }
}

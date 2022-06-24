import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/notificationdata.dart';

class ReadMoreNotification extends StatefulWidget {
  final NotificationData? notification;

  const ReadMoreNotification({Key? key, this.notification}) : super(key: key);

  @override
  State<ReadMoreNotification> createState() => _ReadMoreNotificationState();
}

class _ReadMoreNotificationState extends State<ReadMoreNotification> {
  @override
  Widget build(BuildContext context) {
    var data = widget.notification;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            data!.fullName.text.make(),
            const Spacer(),
            (data.department == "ALL" ? "" : data.department)
                .text
                .sm
                .make()
                .pLTRB(0, 0, 5, 0),
            "${(data.position == "Admin" ? "Principle" : data.position)},"
                .text
                .uppercase
                .sm
                .make()
                .pLTRB(0, 0, 5, 0),
            (formatDate(
                    DateTime.parse(data.createdAt), [MM, ' ', d, ', ', yyyy]))
                .text
                .sm
                .make()
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              data.title,
              style: const TextStyle(
                  height: 1.5, fontSize: 20, fontWeight: FontWeight.bold),
            ).pLTRB(0, 0, 0, 10),
            SelectableLinkify(
              // text: data.description,
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
              style: const TextStyle(height: 1.5, fontSize: 14),
            ),
          ],
        ).pLTRB(18, 10, 18, 10),
      ),
    );
  }
}

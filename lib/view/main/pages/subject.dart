import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:brindavan_student/models/subjects.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class SubjectDetails extends StatefulWidget {
  final Subjects? subject;
  final String? curColor;
  const SubjectDetails(
      {Key? key, required this.subject, required this.curColor})
      : super(key: key);

  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  int? progress;
  final ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloading');

    _receivePort.listen((message) {});
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.subject;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Vx.hexToColor(widget.curColor!),
        foregroundColor: Colors.white,
        title: getInitials(data!.name!).text.white.uppercase.xl3.make(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              data.name!.text.uppercase.xl3.center.bold.make(),
              const SizedBox(
                height: 20,
              ),
              data.desc!.text.center.lineHeight(1.5).make(),
              Divider(),
              'Modules'.text.bold.xl4.make(),
              data.modules.isEmpty
                  ? 'Modules have not been added'.text.gray400.xl.makeCentered()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.modules.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              '${data.modules[index]}'.text.xl.bold.make(),
                            ],
                          ),
                        ).py16();
                      }),
              const SizedBox(
                height: 20,
              ),
              Divider(),
              'Notes'.text.bold.xl4.make(),
              data.notes.isEmpty
                  ? 'Notes have not been added'.text.gray400.xl.makeCentered()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.notes.length,
                      itemBuilder: (context, index) {
                        String fileName = getFileName(data.notes[index]);
                        fileName = shortName(fileName);
                        print(data.notes.length);
                        return Container(
                          child: Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Vx.hexToColor(widget.curColor!),
                                  ),
                                  onPressed: () async {
                                    var rng = new Random();

                                    final status =
                                        await Permission.storage.request();

                                    if (status.isGranted) {
                                      final id =
                                          await FlutterDownloader.enqueue(
                                        url: data.notes[index],
                                        savedDir:
                                            '/storage/emulated/0/Download/',
                                        fileName: rng.nextInt(100).toString() +
                                            fileName,
                                        showNotification: true,
                                        openFileFromNotification: true,
                                      );
                                    } else {
                                      print('permission denied');
                                    }
                                  },
                                  child: fileName.text.make()),
                            ],
                          ),
                        ).py16();
                      }),
            ],
          ).p(20),
        ),
      ),
    );
  }

  String getInitials(String subjectName) => subjectName.isNotEmpty
      ? subjectName.trim().split(' ').map((l) => l[0]).join()
      : '';
  String getFileName(String url) {
    RegExp regExp = new RegExp(r'.+%2F(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    print("${Uri.decodeFull(match.group(1)!)}");
    return Uri.decodeFull(match.group(1)!);
  }

  String shortName(String fileName) {
    int n = fileName.length;
    if (n <= 9) {
      fileName = fileName.substring(0, n - 4) + fileName.substring(n - 4, n);
    } else {
      fileName =
          fileName.substring(0, 9) + '...' + fileName.substring(n - 4, n);
    }
    return fileName;
  }
}

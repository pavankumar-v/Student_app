import 'package:brindavan_student/models/user.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../theme/theme_provider.dart';
import '../reusable_widget/attendance_card.dart';

class Attendance extends StatefulWidget {
  final UserData userData;
  const Attendance({Key? key, required this.userData}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // variables
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('branch')
      .doc('cse')
      .collection('8')
      .snapshots();
  final DatePickerController _controller = DatePickerController();
  void executeAfterBuild() {
    _controller.animateToSelection();
  }

  DateTime _dateTime = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    var MyColor = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      // key: Provider.of<DateKeyProvider>(context).key,
      appBar: AppBar(
        title: 'Attendance'.text.make(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                DateFormat('dd-MM-yyyy').format(_dateTime).text.bold.xl.make(),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          builder: (context, child) => Theme(
                              data: ThemeData().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Theme.of(context).primaryColor,
                                  // onPrimary: Colors.white
                                ),
                                dialogBackgroundColor:
                                    Theme.of(context).backgroundColor,
                              ),
                              child: child!),
                          initialDate: _dateTime,
                          firstDate: DateTime(2008),
                          lastDate: DateTime.now(),
                          context: context);
                      if (newDate != null) {
                        setState(() {
                          _dateTime = newDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today_rounded))
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _userStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading');
                  }
                  String? date = formatter.format(_dateTime).toString();

                  return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        if (data['attendance'][date] == null) {
                          return '${data['id']} No class'.text.center.xl.make();
                        }
                        List<dynamic> attendance = data['attendance'][date];

                        List<dynamic> attendanceList = attendance
                            .where((val) => val.startsWith(
                                widget.userData.usn.toString().toUpperCase()))
                            .toList();

                        return ListView.builder(
                            addAutomaticKeepAlives: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: attendanceList.length,
                            itemBuilder: (conetext, index) {
                              return AttendanceCard(
                                subId: data['name'],
                                usnString: attendanceList.isEmpty
                                    ? 'Error'
                                    : attendanceList[index],
                                dateTime: date,
                              );
                            });
                      }).toList());
                }),
          ],
        ).p(18),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatefulWidget {
  final String? subId;
  final String? usnString;
  final String? dateTime;
   
  const AttendanceCard({Key? key, required this.subId, required this.usnString, required this.dateTime}) : super(key: key);

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  @override
  Widget build(BuildContext context) {
  String? usnString = widget.usnString;
  bool present = usnString![usnString.length - 1] == '1' ? true: false ;

print(DateFormat('MMMEd').format(widget.dateTime!.toDate()!));
  //  dateFormating(){

  // }
  

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 15,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))),
        child: Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: present ? Colors.green : Colors.red, width: 10)),
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.all(18.0),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.subId.toString().toUpperCase().text.bold.lg.make(),
                    const Spacer(),
                    '${DateFormat('MMMEd').format(widget.dateTime!.toDate()!)} - ${widget.usnString?.split('-')[1]}'.text.color(Theme.of(context).hintColor).bold.make()
                  ],
                ),
                const Spacer(),
                (present ? 'Present' : 'Absent').text.bold.color((present ? Vx.hexToColor('#2ECC71') : Colors.red)).make().pLTRB(10, 5, 10, 5).card.color((present ? Vx.hexToColor('#2ECC71') : Colors.red).withAlpha(30)).make(),
              ],
            )),
      ),
    ).py12();
  }
}

import 'dart:async';
import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/main/pages/subject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({
    Key? key,
  }) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  List colors = [
    '#3DAC71',
    '#4F3DAC',
    '#A53DAC',
    '#367eed',
    '#0183D9',
    '#D9016D',
    '#36474f',
    '#8800C1',
  ];

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(elevation: 0, title: 'Subject'.text.xl3.bold.make()),
      body: StreamBuilder<List<Subjects?>?>(
          stream: dataProvider.usersubjects,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      addAutomaticKeepAlives: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        Subjects? data = snapshot.data![index];
                        return Container(
                          color: Colors.transparent,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Material(
                            clipBehavior: Clip.antiAlias,
                            color: Vx.hexToColor(colors[index]),
                            borderRadius: BorderRadius.circular(11),
                            child: InkWell(
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SubjectDetails(
                                            subject: data,
                                            curColor: colors[index],
                                          )));
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  getInitials(data!.name!)
                                      .text
                                      .letterSpacing(3)
                                      .white
                                      .xl4
                                      .uppercase
                                      .make(),
                                  data.id!.text.xl.white.uppercase.make(),
                                  const Spacer(),
                                  data.name!.text.white.sm.uppercase.make(),
                                ],
                              ).p20(),
                            ),
                          ),
                        ).py12();
                      },
                    ),
                  ],
                ).px(20),
              );
            } else {
              return Center(
                child: 'Currently subjects have not been added to this sem'
                    .text
                    .center
                    .bold
                    .color(Theme.of(context).hintColor)
                    .makeCentered()
                    .px(30),
              );
            }
          }),
    );
  }

  String getInitials(String subjectName) => subjectName.isNotEmpty
      ? subjectName.trim().split(' ').map((l) => l[0]).join()
      : '';
}

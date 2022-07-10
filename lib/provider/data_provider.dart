import 'package:brindavan_student/models/dynamicFormModel.dart';
import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  final String? branch;
  final String? sem;
  final String? section;
  DataProvider({this.branch, this.sem, this.section});

  Stream<List<DynamicFormData?>?> get forms => DatabaseService().getForms();
  Stream<UserData> get userData => DatabaseService().curUserData();
  Stream<List<Subjects?>?> get usersubjects =>
      DatabaseService(branch: branch, sem: sem).getSubjects();

  Stream<List<NotificationData?>?> get notificationByBranch =>
      DatabaseService().getNotifications([branch!.toLowerCase()]);
  Stream<List<NotificationData?>?> get notificationBySection =>
      DatabaseService().getNotifications([
        (branch! + sem! + section!).toLowerCase(),
        (branch! + sem!).toLowerCase()
      ]);
  Stream<List<NotificationData?>?> get notificationAll =>
      DatabaseService().getNotifications(["all"]);
}

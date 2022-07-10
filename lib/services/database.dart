import 'dart:async';

import 'package:brindavan_student/models/dynamicFormModel.dart';
import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  String? branch;
  String? sem;
  String? section;
  DatabaseService({this.branch, this.sem, this.section});
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //get usn true or false
  Future checkUsn(usn) async {
    try {
      var result = await _db
          .collection('usncollection')
          .doc('mq6CKVtsEqBoCJvMyeQQ')
          .get()
          .then((doc) => doc.data()![usn]);
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // set usn used
  Future setUsnUsed(usn) async {
    try {
      return await _db
          .collection('usncollection')
          .doc('mq6CKVtsEqBoCJvMyeQQ')
          .set({usn: true}, SetOptions(merge: true)).then(
        (_) => print('success'),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Upsert
  Future updateUserData(String usn, String fullName, int sem, String section,
      String branch) async {
    try {
      var url =
          'https://firebasestorage.googleapis.com/v0/b/brindavan-student-app.appspot.com/o/assets%2Favatars%2Fstudents%2Fdefault.png?alt=media&token=9ccbf074-a4e0-41bf-bba7-6fef4c4c54bf';
      return await _db.collection('users').doc(_auth.currentUser!.uid).set({
        'usn': usn,
        'fullName': fullName,
        'sem': sem,
        'section': section,
        'branch': branch,
        'avatar': url,
        'isActive': true,
        'StarredNotification': []
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //update avatar
  Future updateAvatar(String avatar) async {
    try {
      return await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({'avatar': avatar}, SetOptions(merge: true));
    } catch (e) {
      print('avatar error');
      print(e.toString());
      return null;
    }
  }

  // stream  user data
  Stream<UserData> curUserData() {
    return _db.collection('users').doc(_auth.currentUser!.uid).snapshots().map(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            UserData.fromJson(snapshot.data()!));
  }

  //stream DataNotifcation
  Stream<List<NotificationData?>?> getNotifications(filterArr) {
    print(filterArr);
    return _db
        .collection('notifications')
        .limit(100)
        .orderBy('createdAt', descending: true)
        .where("tags", arrayContainsAny: filterArr)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationData.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Add to stared notifications
  void starNotification(notificationId, fullName, title) {
    print(notificationId);
    try {
      _db.collection("users").doc(_auth.currentUser!.uid).set({
        "StarredNotification": FieldValue.arrayUnion([
          {"id": notificationId, "fullName": fullName, "title": title}
        ])
      }, SetOptions(merge: true)).then((value) => print("starred"));
    } catch (e) {
      print(e);
    }
  }

  //
  void removeFromStared(notificationId, fullName, title) {
    try {
      _db.collection("users").doc(_auth.currentUser!.uid).set({
        "StarredNotification": FieldValue.arrayRemove([
          {"id": notificationId, "fullName": fullName, "title": title}
        ])
      }, SetOptions(merge: true)).then((value) => print("removed"));
    } catch (e) {
      print(e);
    }
  }

  //stared notification
  Future<dynamic>? getStarredNotifications(docId) async {
    try {
      var result = await _db
          .collection('notifications')
          .doc(docId)
          .get()
          .then((doc) => doc.data());
      // print(result);
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<DynamicFormData?>?> getForms() {
    return _db
        .collection('global')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DynamicFormData.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Subjects?>?> getSubjects() {
    return _db
        .collection('branch')
        .doc(branch.toString().toLowerCase())
        .collection(sem.toString())
        .orderBy('id')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Subjects.fromJson(doc.data())).toList());
  }

  Future<dynamic> getUsn() async {
    try {
      dynamic result;
      result = await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => value.data()!);
      return result;
    } catch (e) {
      print('error$e');
      return null;
    }
  }

  Future<dynamic> getImg() {
    var result = _db
        .collection('assets')
        .doc('drawer_bg')
        .get()
        .then((value) => value.data()!['drawerBg']);

    return result;
  }
}

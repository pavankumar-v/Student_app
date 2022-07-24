import 'dart:async';

import 'package:brindavan_student/models/dynamicFormModel.dart';
import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/file.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  String? branch;
  String? sem;
  String? section;
  DatabaseService({this.branch, this.sem, this.section});
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //get usn true or false
  Future checkUsn(usn, branch) async {
    try {
      var result = await _db
          .collection('branch/${branch.toString().toLowerCase()}/others')
          .doc('usncollection')
          .get()
          .then((doc) => doc.data()![usn]);

      print("usn result $result");

      return result;
    } catch (e) {
      print("usn error");
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> getDetails() async {
    try {
      return await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => value.data()!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // set usn used
  Future setUsnUsed(usn, branch) async {
    try {
      return await _db
          .collection("branch/${branch.toString().toLowerCase()}/others")
          .doc('usncollection')
          .set({usn: false}, SetOptions(merge: true)).then(
        (_) => print('success'),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Upsert
  Future updateUserData(String usn, String fullName, int sem, String section,
      String branch) async {
    print(fullName);
    print(usn);
    print(branch);
    print(sem);
    print(section);
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
  Stream<List<NotificationData?>?> getNotifications(filterArr, collectionName) {
    print(filterArr);
    return _db
        .collection(collectionName)
        .limit(100)
        .orderBy('createdAt', descending: true)
        .where("tags", arrayContainsAny: filterArr)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationData.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Add to stared notifications
  void starNotification(notificationId, fullName, title, department) {
    try {
      print(notificationId);
      print(fullName);
      print(title);
      print(department);
      _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({
            "StarredNotification": FieldValue.arrayUnion([
              {
                "id": notificationId,
                "fullName": fullName,
                "title": title,
                "department": department
              }
            ])
          }, SetOptions(merge: true))
          .then((value) => print("starred"))
          .catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

  //
  void removeFromStared(notificationId, fullName, title, department) {
    try {
      print(notificationId);
      print(fullName);
      print(title);
      print(department);
      _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({
            "StarredNotification": FieldValue.arrayRemove([
              {
                "id": notificationId,
                "fullName": fullName,
                "title": title,
                "department": department
              }
            ])
          }, SetOptions(merge: true))
          .then((value) => print("removed"))
          .catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

  //stared notification
  Future<dynamic>? getStarredNotifications(docId, department) async {
    try {
      var result = await _db
          .collection(department == 'ALL'
              ? 'notifications'
              : "branch/${department.toString().toLowerCase()}/notifications")
          .doc(docId)
          .get()
          .then((doc) => doc.data());
      // print(result);
      return result;
    } catch (e) {
      print(e);
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

  Future<dynamic> getImg() {
    var result = _db
        .collection('assets')
        .doc('drawer_bg')
        .get()
        .then((value) => value.data()!['drawerBg']);

    return result;
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;

          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}

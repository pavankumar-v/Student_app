import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestService {
  var firebaseUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //test db
  void addData() {
    _db.collection('dummy').add({
      "name": "jhon",
      "age": 50,
      "email": "exampleemail.com",
      "address": {"street": "street 24", "city": "new york"}
    }).then((value) => print(value.id));
  }

  //test db upsert add it not exists or update
  void setData() {
    _db.collection('dummy').doc(firebaseUser.uid).set({
      "name": "jhon",
      "age": 50,
      "email": "example@email.com",
      "address": {"street": "street 24", "city": "new york"}
    }, SetOptions(merge: true)).then((value) => print('success!'));
  }

  void updateData() {
    _db.collection('dummy').doc(firebaseUser.uid).update({
      "age": 60,
      "familyName": "Haddad",
      "address.street": "Street 50",
      "address.country": "USA",
    }).then((_) => print('success!'));
  }

  // set with merge true will work as both update and add
  void upsertData() {
    _db.collection('dummy').doc(firebaseUser.uid).update({
      "charecteristics": FieldValue.arrayUnion(["generous", "loving", "loyal"])
    }).then((_) => print('success!'));
  }

  //sub collections
  void addSub() {
    _db.collection('dummy').add({
      "name": "jhon",
      "age": 50,
      "email": "example@email.com",
      "address": {"street": "street 24", "city": "new york"}
    }).then((value) {
      _db
          .collection('dummy')
          .doc(value.id)
          .collection('pets')
          .add({"petName": "blacky", "petType": "dog", "petAge": 1});
    });
  }

  // delete doc
  void deleteDoc() {
    _db
        .collection('dummy')
        .doc(firebaseUser.uid)
        .delete()
        .then((_) => print('success!'));
  }

  //delete field
  void deleteField() {
    _db
        .collection('dummy')
        .doc(firebaseUser.uid)
        .update({"age": FieldValue.delete()});
  }

  // get data
  void getData() {
    print('retriviing...');
    _db
        .collection('dummy')
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              print(result.data());
            }));
  }

  // retrive a document
  Future<dynamic> getDocData() async {
    return await _db
        .collection('users')
        .doc('pSFJGZcxq0SJxf72HjKOwg1fQnA3')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) => value.data()!);
  }

  // retvieve sub collectinos
  void getsubData() {
    print('retriving sub data');
    _db.collection('dummy').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _db
            .collection('dummy')
            .doc(result.id)
            .collection('pets')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            print(result.data());
          });
        });
      });
    });
  }



  getRealTimeData() {
    return _db
        .collection('dummy')
        .where('address.city', isEqualTo: 'ASIA')
        .snapshots()
        .listen((result) {
      result.docs.forEach((result) {
        result.data();
      });
    });
  }

  //set notifications
  void addNotifications() {
    _db.collection('notifications').add({
      'fullName': 'Manoj',
      'position': 'hod cse',
      'title': 'Title is Dummy',
      'description':
          'This is a dummy description, that allows student ti notify the notification in detail',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<UserData> getUserData() {
    print('user future called');
    return _db.collection('users').doc(firebaseUser.uid).get().then(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            UserData.fromJson(snapshot.data()!['subjects']));
  }



  Stream<Subjects?>? getSubjects() {
    try {
      print('subjects Stream running');
      return _db.collection('subjects').doc('6').snapshots().map(
          (DocumentSnapshot<Map<String, dynamic>> snapshot) =>
              Subjects.fromJson(snapshot.data()!));
    } catch (e) {
      print('parsing error occured');
      print(e.toString());
      return null;
    }
  }

  Future<List<NotificationData?>?> getFutureNoti() {
    print('notification future Called');
    return _db
        .collection('notifications')
        .where('createdAt',
            isGreaterThan:
                DateTime.now().add(Duration(days: -10)).toIso8601String())
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) => value.docs
            .map((e) => NotificationData.fromJson(e.data()))
            .toList());
  }



 
}

import 'package:brindavan_student/services/database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarSelector extends StatefulWidget {
  const AvatarSelector({Key? key}) : super(key: key);

  @override
  _AvatarSelectorState createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  final DatabaseService _db = DatabaseService();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String error = '';
  final _enabled = true;
  String path = '';
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: 'Select Avatar'.text.make(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _firebaseFirestore
                      .collection('assets')
                      .doc('avatars')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List imgList = snapshot.data!['avatars'];
                      return GridView.builder(
                          // scrollDirection: Axis.vertical,
                          itemCount: imgList.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  path = imgList[index];
                                });
                              },
                              child: CircleAvatar(
                                  backgroundColor: Colors.black12,
                                  backgroundImage: CachedNetworkImageProvider(
                                      imgList[index])),
                            ).p12();
                          }).p12();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text('something went wrong');
                    }
                  }),
              path == ''
                  ? Container()
                  : CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(path)),
              ElevatedButton(
                  onPressed: _enabled == true
                      ? () {
                          dynamic result = _db.updateAvatar(path);
                          if (result != null) {
                            setState(() {
                              error = 'success';
                            });
                          }
                          Navigator.pop(context);
                        }
                      : null,
                  child: 'submit'.text.make()),
            ],
          ),
        ),
      ),
    );
  }
}

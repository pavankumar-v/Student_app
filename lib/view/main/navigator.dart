import 'dart:math';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/main/pages/attendanceView.dart';
import 'package:brindavan_student/view/main/pages/demo.dart';
import 'package:brindavan_student/view/main/pages/dynamicForms.dart';
import 'package:brindavan_student/view/main/pages/enter_details.dart';
import 'package:brindavan_student/view/main/pages/home.dart';
import 'package:brindavan_student/view/main/pages/notification.dart';
import 'package:brindavan_student/view/main/pages/placementView.dart';
import 'package:brindavan_student/view/main/pages/profile_page.dart';
import 'package:brindavan_student/view/main/pages/starredNotification.dart';
import 'package:brindavan_student/view/main/pages/subject_list.dart';
import 'package:brindavan_student/view/main/pages/theme.dart';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:brindavan_student/view/main/pages/warningView.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme/theme_provider.dart';

class Navigate extends StatefulWidget {
  const Navigate({Key? key}) : super(key: key);

  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate>
    with AutomaticKeepAliveClientMixin<Navigate> {
  @override
  bool get wantKeepAlive => true;

  final AuthService _auth = AuthService();
  final PageStorageBucket _bucket = PageStorageBucket();

  var regex = RegExp(r'[A-Za-z]');

  Stream<UserData>? data;
  MyUser? user;
  String? imgUrl;

  bool loading = false;

  int _currentIndex = 0;
  List<Widget> tabs = [
    const Home(),
    const NotificationList(),
    const SubjectList(),
    const PlacementsView()
  ];

  @override
  void dispose() {
    // dataProvider!.dispose();
    super.dispose();
  }

  Future _initImg() async {
    List<dynamic> result = await DatabaseService().getImg();
    var randomNames = Random().nextInt(result.length);
    setState(() {
      imgUrl = result[randomNames];
    });
  }

  @override
  void initState() {
    _initImg();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    data = dataProvider.userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var MyColor = Theme.of(context).extension<MyColors>()!;
    final user = Provider.of<MyUser?>(context);
    var buttonStyle = ElevatedButton.styleFrom(
      elevation: 10,
      primary: Theme.of(context).backgroundColor,
      onPrimary: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    super.build(context);

    return loading
        ? const Loading()
        : StreamBuilder<UserData?>(
            stream: data,
            builder: (context, snapshot) {
              UserData? userData = snapshot.data;

              if (snapshot.hasData) {
                // ignore: unnecessary_null_comparison
                if (userData!.fullName.isEmpty) {
                  return EnterDetails(userData: userData);
                } else if (!userData.isActive) {
                  return const UserInactive();
                } else {
                  return Scaffold(
                      extendBody: true,
                      body: IndexedStack(
                        index: _currentIndex,
                        children: tabs,
                      ),
                      bottomNavigationBar: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: BottomNavigationBar(
                          currentIndex: _currentIndex,
                          backgroundColor: Theme.of(context).primaryColor,
                          selectedItemColor:
                              Theme.of(context).colorScheme.onPrimary,
                          unselectedItemColor: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(.60),
                          selectedFontSize: 10,
                          selectedLabelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          unselectedFontSize: 10,
                          type: BottomNavigationBarType.fixed,
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home_rounded),
                              label: 'Home',
                            ),

                            BottomNavigationBarItem(
                              icon: Icon(Icons.notifications),
                              label: 'Notification',
                            ),

                            BottomNavigationBarItem(
                              icon: Icon(Icons.article_rounded),
                              label: 'Subjects',
                            ),
                            // BottomNavigationBarItem(
                            //   icon: Icon(
                            //     Icons.business_outlined,
                            //   ),
                            //   label: 'Placements',
                            // ),
                          ],
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ).h(80),
                      ).p(17),
                      drawer: SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Drawer(
                            child: Container(
                          color: Theme.of(context).backgroundColor,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.60,
                                child: DrawerHeader(
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              '$imgUrl'),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.darken),
                                        )),
                                    child: UserAccountsDrawerHeader(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                        color: Colors.transparent,
                                      ),
                                      accountName:
                                          userData.fullName.text.make(),
                                      accountEmail:
                                          '${user!.email}'.text.make(),
                                      currentAccountPicture: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AvatarList()));
                                        },
                                        child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                          userData.avatar,
                                        )),
                                      ),
                                    )),
                              ),
                              Container(
                                  color: Theme.of(context).canvasColor,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                            userData: userData,
                                                            imgUrl: imgUrl,
                                                          )));
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.person_rounded,
                                              color: MyColor.textColor,
                                            ),
                                            title: 'Profile'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ThemeSwitcher()));
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.palette_rounded,
                                              color: MyColor.textColor,
                                            ),
                                            title: 'Theme'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Attendance(
                                                            userData: userData,
                                                          )));
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.app_registration_rounded,
                                              color: MyColor.textColor,
                                            ),
                                            title: 'Attendace'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const StarredNotification()));
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.bookmark,
                                              color: MyColor.textColor,
                                            ),
                                            title: 'Saved'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DynamicForms()));
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.description_rounded,
                                              color: MyColor.textColor,
                                            ),
                                            title: 'Forms'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () async {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200),
                                                () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await _auth.signOut();
                                            });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.logout_rounded,
                                              color: MyColor.textColor,
                                            ),
                                            title: 'Sign Out'.text.make(),
                                          ),
                                        ).p12(),
                                        'Version 1.0.0'
                                            .text
                                            .color(Theme.of(context).hintColor)
                                            .hairLine
                                            .lg
                                            .make()
                                            .p16(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary:
                                                Theme.of(context).primaryColor,
                                            onPrimary: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: const Icon(Icons
                                                    .settings_accessibility_rounded)
                                                .iconColor(Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                            title: 'About'
                                                .text
                                                .color(Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)
                                                .make(),
                                          ),
                                        ).p12(),
                                      ])).p12()
                            ],
                          ),
                        )),
                      ));
                }
              } else {
                return const Loading();
              }
            });
  }
}

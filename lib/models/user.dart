class MyUser {
  final String uid;
  final String? email;

  MyUser({required this.uid, required this.email});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      uid: json['uid'],
      email: json['email'],
    );
  }
}

class UserData {
  // final String uid;
  final String usn;
  final String fullName;
  final int? sem;
  final String branch;
  final String section;
  final bool isActive;
  final String avatar;

  UserData({
    required this.usn,
    required this.fullName,
    required this.sem,
    required this.branch,
    required this.section,
    required this.isActive,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      usn: json['usn'],
      fullName: json['fullName'],
      sem: json['sem'],
      branch: json['branch'],
      section: json['section'],
      isActive: json['isActive'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usn': usn,
      'fullName': fullName,
      'sem': sem,
      'branch': branch,
      'section': section,
      'avatar': avatar
    };
  }
}

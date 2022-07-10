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
  final List<StarredPostData>? starredNotifications;

  UserData({
    required this.usn,
    required this.fullName,
    required this.sem,
    required this.branch,
    required this.section,
    required this.isActive,
    required this.avatar,
    this.starredNotifications,
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
        starredNotifications: parsedNotifications(json));
  }

  static List<StarredPostData> parsedNotifications(parsedJson) {
    var list = parsedJson['StarredNotification'] as List;
    List<StarredPostData> postsList =
        list.map((data) => StarredPostData.fromJson(data)).toList();
    return postsList;
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

class StarredPostData {
  final String? id;
  final String? fullName;
  final String? title;
  StarredPostData({
    this.id,
    this.fullName,
    this.title,
  });

  factory StarredPostData.fromJson(Map<String, dynamic> parsedJson) {
    return StarredPostData(
        id: parsedJson['id'],
        fullName: parsedJson['fullName'],
        title: parsedJson['title']);
  }
}

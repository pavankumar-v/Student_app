// class Subject {
//   final String id;
//   final String name;
//   final String description;
//   final List<String> modules;
//   final List<String> notes;

//   Subject(
//       {required this.id,
//       required this.name,
//       required this.description,
//       required this.modules,
//       required this.notes});

//   factory Subject.fromJson(Map<String, dynamic> parsedJson) {
//     return Subject(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       description: parsedJson['description'],
//       modules: parseModules(parsedJson['modules']),
//       notes: parseModules(parsedJson['notes']),
//     );
//   }

//   static List<String> parseModules(modulesJson) {
//     List<String> modulesList = List<String>.from(modulesJson);

//     return modulesList;
//   }

//   static List<String> parseNotes(notesJson) {
//     List<String> notesList = List<String>.from(notesJson);

//     return notesList;
//   }
// }

// class Subjects {
//   final List<Subject> subjects;

//   Subjects({required this.subjects});

//   factory Subjects.fromJson(Map<String, dynamic> json) {
//     return Subjects(subjects: parseSubjects(json));
//   }

//   static List<Subject> parseSubjects(subjectsJson) {
//     var list = subjectsJson['subjects'] as List;
//     List<Subject> subjectList =
//         list.map((data) => Subject.fromJson(data)).toList();

//     return subjectList;
//   }
// }

class Subjects {
  final String? id;
  final String? name;
  final String? desc;
  final List<String> modules;
  final List<String> notes;

  Subjects(
      {required this.id,
      required this.name,
      required this.desc,
      required this.modules,
      required this.notes});

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
        id: json['id'],
        name: json['name'],
        desc: json['description'],
        modules: parseModules(json['modules']),
        notes: parseNotes(json['notes']));
  }

  get description => null;

  static List<String> parseModules(modulesJson) {
    List<String> modulesList = List<String>.from(modulesJson);

    return modulesList;
  }

  static List<String> parseNotes(notesJson) {
    List<String> notesList = List<String>.from(notesJson);

    return notesList;
  }
}

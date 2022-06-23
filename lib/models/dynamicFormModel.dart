class DynamicFormData {
  final String name;
  final String description;
  final bool isActive;
  // final bool isFilled;
  final List<dynamic> form;
  final String formId;
  final String sheetName;
  final String createdAt;

  DynamicFormData(
      {required this.name,
      required this.description,
      required this.isActive,
      // required this.isFilled,
      required this.form,
      required this.sheetName,
      required this.formId,
      required this.createdAt});

  factory DynamicFormData.fromJson(Map<String, dynamic> json) {
    return DynamicFormData(
        name: json['name'],
        description: json['description'],
        isActive: json['isActive'],
        form: json['form'],
        formId: json['formId'],
        sheetName: json['sheetName'],
        createdAt: json['createdAt']);
  }
}

class MaterialModel {
  late String fileName;
  late String filePath;
  late bool isLocal;
  late int? totalPages;
  late int initialPage;
  late bool hasBeenModified;
  late String courseCode;

  MaterialModel({
    required this.fileName,
    required this.filePath,
    required this.isLocal,
    this.initialPage = 0,
    this.totalPages,
    this.hasBeenModified = false,
    required this.courseCode,
  });

  MaterialModel.toJson(Map<String, dynamic> json) {
    fileName = json["file_name"];
    filePath = json["file_path"];
    isLocal = json["isLocal"];
    totalPages = json["total_pages"];
    initialPage = json["initial_page"];
    hasBeenModified = json["has_been_modified"] ?? false;
    courseCode = json["course_code"];
  }

  Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "file_path": filePath,
        "isLocal": isLocal,
        "total_pages": totalPages,
        "initial_page": initialPage,
        "has_been_modified": hasBeenModified,
        "course_code": courseCode,
      };

  @override
  bool operator ==(Object other) {
    if (other is MaterialModel &&
        other.fileName == fileName &&
        other.filePath == filePath &&
        other.isLocal == isLocal &&
        other.initialPage == initialPage &&
        other.totalPages == totalPages &&
        other.hasBeenModified == hasBeenModified &&
        other.courseCode == courseCode) {
      return true;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
        fileName,
        filePath,
        isLocal,
        totalPages,
        initialPage,
        hasBeenModified,
        courseCode,
      );
}

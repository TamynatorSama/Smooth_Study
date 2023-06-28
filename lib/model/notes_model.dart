class NoteModel {
  final String materialName;
  final String head;
  final String body;
  final String uid;

  const NoteModel({
    required this.body,
    required this.head,
    required this.materialName,
    required this.uid,
  });

  toJson() => {
        "head": head,
        "body": body,
        "materialName": materialName,
        "uid": uid,
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        body: json["body"],
        head: json["head"] ?? '',
        materialName: json["materialName"],
        uid: json['uid'],
      );

  factory NoteModel.newNote({
    required String materialName,
    required String uid,
  }) =>
      NoteModel(
        body: '',
        head: '',
        materialName: materialName,
        uid: uid,
      );

  @override
  toString() => 'Note: $body';

  @override
  operator ==(Object other) =>
      other is NoteModel &&
      body == other.body &&
      head == other.head &&
      uid == other.uid &&
      materialName == other.materialName;

  @override
  int get hashCode => Object.hash(
        materialName,
        uid,
        head,
        body,
      );
}

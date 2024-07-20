class Download {
  int? id;
  String? videopath;
  String? imagepath;
  String? type;

  Download({this.id, this.videopath, this.imagepath, this.type});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'imagepath': imagepath, 'videopath': videopath, 'type': type};
    return map;
  }

  Download.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    imagepath = map['imagepath'] ?? '';
    videopath = map['videopath'];
    type = map['type'];
  }
}

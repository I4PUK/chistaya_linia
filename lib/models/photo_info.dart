class PhotoInfo {
  String? filename;
  String? name;
  String? mime;
  String? extension;
  String? url;
  int? size;

  PhotoInfo({this.filename, this.name, this.mime, this.extension, this.url});

  PhotoInfo.fromJson(Map<String, dynamic> json) {
    filename = json['data']['image']['filename'];
    name = json['data']['image']['name'];
    mime = json['data']['image']['mime'];
    extension = json['data']['image']['extension'];
    url = json['data']['image']['url'];
    size = json['data']['size'];
  }
}

import 'package:uuid/uuid.dart';

class LinkModel {
  late String id;
  late String linkName;
  late String linkUrl;
  // late String linkSvg;
  late bool isLocal;
  static Set<String> createdLinks = {};
  static Set<String> deletedLinks = {};
  static Set<String> updatedLinks = {};

  static bool linksSynced = true;

  LinkModel(
      {required this.linkName,
      /*required this.linkSvg,*/ required this.linkUrl,
      this.isLocal = false}) {
    id = const Uuid().v4();
    // if (linkSvg.toLowerCase().contains("assets/images")) {
    //   isLocal = true;
    // } else {
    //   isLocal = false;
    // }
  }

  LinkModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    linkName = json["link_name"];
    linkUrl = json["link_url"];
    isLocal = json["isLocal"] ?? false;
  }

  Map<String,dynamic> toJson(String userId)=>{
    "id":id,
    "link_name":linkName,
    "link_url":linkUrl,
    "user_id": userId
  };

  @override
  bool operator ==(Object other) {
    if (other is LinkModel) {
      if (other.id == id &&
          other.linkName == linkName &&
          other.linkUrl == linkUrl) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(linkName, linkUrl, id);

  @override
  String toString() => "LinkModel(link_name:$linkName,link_url:$linkUrl)";
}

enum LinkUpdates { createdLinks, updatedLink, deletedLinks }

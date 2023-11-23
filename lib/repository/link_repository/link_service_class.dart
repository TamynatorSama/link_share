import 'package:link_share/models/link_model.dart';

abstract class LinkService{
  Future<Map<String,dynamic>> getLinks(String userId);
  Future<bool> syncData(List<LinkModel> currentModel,String userId);
}



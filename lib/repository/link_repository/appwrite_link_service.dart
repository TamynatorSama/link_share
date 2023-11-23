import 'package:appwrite/appwrite.dart';
import 'package:link_share/models/link_model.dart';
import 'package:link_share/repository/link_repository/link_service_class.dart';
import 'package:link_share/utils/appwrite_initializer.dart';
import 'package:link_share/utils/constants.dart';

class AppWriteLinkService implements LinkService {
  final databases = Databases(AppWriteInit.appClient);

  @override
  Future<Map<String,dynamic>> getLinks(String userId) async {
    try {
      final documents = await databases.listDocuments(
          databaseId: appWriteDatabaseId,
          collectionId: appWriteLinkCollectionId,
          queries: [Query.equal('user_id', userId)]);

      if (documents.documents.isNotEmpty) {
        List<LinkModel> userLinks =
            documents.documents.map((e) => LinkModel.fromJson(e.data)).toList();
        return {
          "status": true,
          "message": "links retrieved successfully",
          "result": userLinks
        };
      }
      return {
        "status": true,
        "message": "links retrieved successfully",
        "result": []
      };
    } on AppwriteException catch (e) {
      return {"status": false, "message": e.message};
    } catch (_) {
      return {"status": false, "message": "something went wrong"};
    }
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:link_share/models/link_model.dart';
import 'package:link_share/repository/link_repository/link_service_class.dart';
import 'package:link_share/utils/appwrite_initializer.dart';
import 'package:link_share/utils/constants.dart';

class AppWriteLinkService implements LinkService {
  final databases = Databases(AppWriteInit.appClient);

  @override
  Future<Map<String, dynamic>> getLinks(String userId) async {
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
        "result": <LinkModel>[]
      };
    } on AppwriteException catch (e) {
      return {"status": false, "message": e.message};
    } catch (_) {
      return {"status": false, "message": "something went wrong"};
    }
  }

  @override
  Future<bool> syncData(List<LinkModel> currentModel, String userId) async {
    List<Map<String, dynamic>> createdLinks =
        sortoutCreatedLinks(currentModel, userId);
    bool hasError = false;
    try {
      if (createdLinks.isNotEmpty) {
        await Future.forEach(createdLinks, (element) async {
          try {
            await databases.createDocument(
                databaseId: appWriteDatabaseId,
                collectionId: appWriteLinkCollectionId,
                documentId: element["id"],
                data: element);
            LinkModel.createdLinks.remove(element["id"]);
          } on AppwriteException catch (e) {
            hasError = true;
            if (kDebugMode) print(e.message);
          }
        });
        if (!hasError) {
          LinkModel.linksSynced = true;
        }
      }
      if (LinkModel.deletedLinks.isNotEmpty) {
        List elementToDelete = [];
        await Future.forEach(LinkModel.deletedLinks, (element) async {
          try {
            await databases.deleteDocument(
                databaseId: appWriteDatabaseId,
                collectionId: appWriteLinkCollectionId,
                documentId: element);
            elementToDelete.add(element);
          } on AppwriteException catch (e) {
            hasError = true;
            if (kDebugMode) print(e.message);
          } catch (e) {
            hasError = true;
            if (kDebugMode) print(e);
          }
        });
        LinkModel.deletedLinks.removeAll(elementToDelete);
        if (!hasError) {
          LinkModel.linksSynced = true;
        }
      }
      if (LinkModel.updatedLinks.isNotEmpty) {
        await Future.forEach(LinkModel.updatedLinks, (element) async {
          try {
            await databases.updateDocument(
                databaseId: appWriteDatabaseId,
                collectionId: appWriteLinkCollectionId,
                documentId: element,
                data: currentModel
                    .firstWhere((elem) => elem.id == element)
                    .toJson(userId));
          } on AppwriteException catch (e) {
            hasError = true;
            if (kDebugMode) print(e.message);
          } catch (e) {
            hasError = true;
            if (kDebugMode) print(e);
          }
        });
        if (!hasError) {
          LinkModel.linksSynced = true;
          LinkModel.updatedLinks = {};
        }
      }
    } catch (e) {
      hasError = true;
    }

    return hasError;
  }

  List<Map<String, dynamic>> sortoutCreatedLinks(
      List<LinkModel> currentModel, String userId) {
    List<Map<String, dynamic>> returnableList = [];
    if (LinkModel.createdLinks.isNotEmpty) {
      for (LinkModel model in currentModel) {
        if (model.linkName.isNotEmpty &&
            model.linkUrl.isNotEmpty &&
            LinkModel.createdLinks.contains(model.id)) {
          returnableList.add(model.toJson(userId));
        }
      }
    }
    return returnableList;
  }
}

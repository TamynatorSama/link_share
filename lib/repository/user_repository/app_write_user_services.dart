import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:link_share/repository/user_repository/user_service_interface.dart';
import 'package:link_share/utils/appwrite_initializer.dart';
import 'package:link_share/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class AppWriteUserService implements UserServices {
  Account account = Account(AppWriteInit.appClient);

  @override
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      await account.createEmailSession(email: email, password: password);

      User loggedInUser = await account.get();

      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setBool("isLoggedIn", true);
      return {
        'status': true,
        'message': 'user created successfully',
        'result': loggedInUser
      };
    } catch (e) {
      if (e is AppwriteException) {
        return {
          'status': false,
          'message': e.message ?? "",
        };
      }
      return {
        'status': false,
        'message': "unable to process your request",
      };
    }
  }

  @override
  Future<Map<String, dynamic>> registerUser(
      String email, String password) async {
    try {
      User newUser = await account.create(
          userId: ID.unique(), email: email, password: password);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await account.createEmailSession(
          email: newUser.email, password: newUser.password ?? password);

      preferences.setBool("isLoggedIn", true);
      return {
        'status': true,
        'message': 'user created successfully',
        'result': newUser
      };
    } catch (e) {
      if (e is AppwriteException) {
        return {
          'status': false,
          'message': e.message ?? "",
        };
      }
      return {
        'status': false,
        'message': "unable to process your request",
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
      {String? firstName, String? lastName, String? picturePath,String? pictureId}) async {
    User newUser = await account.get();
    Uint8List? image;

    if (firstName != null || lastName != null) {
      try {
        User updatedUser = await account.updatePrefs(
            prefs: {...newUser.prefs.data,"first_name": firstName, "last_name": lastName});

        newUser = updatedUser;
      } on AppwriteException catch (e) {
        return {"status": false, "message": e.message};
      } catch (e) {
        return {"status": false, "message": e.toString()};
      }
    }
    if (picturePath != null) {
      Storage storage = Storage(AppWriteInit.appClient);
      try {
        File result = await storage.createFile(
          bucketId: profilePictureBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: picturePath,
          ),
        );

        

        if (pictureId != null) {
          await storage.deleteFile(
              bucketId: profilePictureBucketId, fileId: pictureId);
        }

        User updatedUser =
            await account.updatePrefs(prefs: {...newUser.prefs.data,"profile_id": result.$id});
        newUser = updatedUser;

        await storage
            .getFileView(
          bucketId: profilePictureBucketId,
          fileId: result.$id,
        )
            .then((bytes) {
          image = bytes;
        });
      } on AppwriteException catch (e) {
        return {"status": false, "message": e.message};
      } catch (e) {
        return {"status": false, "message": e.toString()};
      }
    }
    return {
      "status": true,
      "result": newUser,
      "image": image,
      "message": "Profile Successfully updated"
    };
  }
}

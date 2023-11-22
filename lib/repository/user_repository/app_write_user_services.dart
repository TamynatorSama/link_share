import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:link_share/repository/user_repository/user_service_interface.dart';
import 'package:link_share/utils/appwrite_initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWriteUserService implements UserServices {
  Account account = Account(AppWriteInit.appClient);
  
  @override
  Future<Map<String, dynamic>> loginUser(String email, String password) async{
    try {
        await account.createEmailSession(
            email: email, password: password);

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
}

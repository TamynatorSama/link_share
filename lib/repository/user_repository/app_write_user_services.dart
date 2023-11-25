import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  Future<Map<String, dynamic>> updateProfile(UpdateType update,{String? firstName, String? lastName, String? picturePath}) async{
    if(firstName != null || lastName !=null){
      User currentUser =  await account.get();
      var nameArray = currentUser.name.trim().split(" ");
      
      // print("$firstName${lastName ==null ?"":$}");
      print(currentUser.name.length);
      String name = "";
      
      if(currentUser.name.isEmpty){
        name = '${firstName??""}${lastName??""}';
      }
      if(nameArray.length == 1 && currentUser.name.isNotEmpty){
        name = '${firstName??nameArray[0]}${lastName??""}';
      }
      if(nameArray.length > 1 && currentUser.name.isNotEmpty){
        name = '${firstName??nameArray[0]}${lastName??nameArray.last}';
      }
      try {
        User updatedUser = await account.updateName(name: name);
        print(updatedUser.name);
      } on AppwriteException catch(e){
        if(kDebugMode) print(e.message);
      }
      catch (e) {
        if(kDebugMode) print(e);
      }
      
    }
    return {};
  }
}

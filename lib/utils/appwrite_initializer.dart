import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:link_share/utils/constants.dart';

class AppWriteInit {
  static late Client appClient;
  static bool isLoggedIn = false;

  static Future initClient() async {
    appClient = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(projectKey);
    SharedPreferences instance = await SharedPreferences.getInstance();
    isLoggedIn =  instance.getBool("isLoggedIn")??false ;
  }
}

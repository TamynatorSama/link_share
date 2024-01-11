
abstract class UserServices{
  Future<Map<String,dynamic>> loginUser(String email, String password);
  Future<Map<String,dynamic>> registerUser(String email, String password);
  Future<Map<String,dynamic>> updateProfile({String? firstName,String? lastName,String? picturePath,String? pictureId});
}
enum UpdateType{
  name,
  profilePicture,
  multiple
}
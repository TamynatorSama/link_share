
abstract class UserServices{
  Future<Map<String,dynamic>> loginUser(String email, String password);
  Future<Map<String,dynamic>> registerUser(String email, String password);
  Future<Map<String,dynamic>> updateProfile(UpdateType update,{String? firstName,String? lastName,String? picturePath});
}
enum UpdateType{
  name,
  profilePicture,
  multiple
}
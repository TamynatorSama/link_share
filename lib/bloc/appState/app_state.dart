import 'package:appwrite/models.dart';
import 'package:link_share/models/link_model.dart';

class AppState {
  final bool isLoading;
  final User? currentUser;
  final List<LinkModel> links;
  AppState({this.isLoading = false, this.currentUser, this.links = const []}) {
    if (currentUser != null) {
      print(currentUser!.prefs.data);
    }
  }

  AppState copyWith({bool? loading, User? updatedUser, List<LinkModel>? updatedLinks}){
    return AppState(
          isLoading: loading ?? isLoading,
          currentUser: updatedUser ?? currentUser,
          links: updatedLinks ?? links);
  }

}

// extension on AppState {
//   AppState copyWith(
//           {bool? loading, User? updatedUser, List<LinkModel>? updatedLinks}) =>
      // AppState(
      //     isLoading: loading ?? isLoading,
      //     currentUser: updatedUser ?? currentUser,
      //     links: updatedLinks ?? links);
// }

// AppState state = AppState().copyWith();

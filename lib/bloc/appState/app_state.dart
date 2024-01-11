import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:link_share/models/link_model.dart';

class AppState {
  final bool isLoading;
  final User? currentUser;
  final List<LinkModel> links;
  Uint8List? image;
  AppState({
    this.isLoading = false,
    this.currentUser,
    this.links = const [],
    this.image
  });

  AppState copyWith(
      {bool? loading, User? updatedUser, List<LinkModel>? updatedLinks,Uint8List? image}) {
    return AppState(
        isLoading: loading ?? isLoading,
        currentUser: updatedUser ?? currentUser,
        links: updatedLinks ?? links,
        image: image?? this.image
        );
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

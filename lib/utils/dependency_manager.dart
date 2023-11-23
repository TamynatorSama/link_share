import 'package:link_share/repository/link_repository/appwrite_link_service.dart';
import 'package:link_share/repository/link_repository/link_service_class.dart';
import 'package:link_share/repository/user_repository/app_write_user_services.dart';
import 'package:link_share/repository/user_repository/user_service_interface.dart';

UserServices currentUserService = AppWriteUserService();
LinkService currentLinkService = AppWriteLinkService();
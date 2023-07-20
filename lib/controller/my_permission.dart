import 'package:permission_handler/permission_handler.dart';

class MyPermissionPhoto {
  Future<PermissionStatus>init() async{
    PermissionStatus status = await Permission.photos.status;
    return checkPermission(status);
}

  Future<PermissionStatus> checkPermission(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.permanentlyDenied:
        return Future.error("Toujours refusé");
      case PermissionStatus.denied:
      case PermissionStatus.provisional:
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.granted:
        return Permission.photos.request().then((value) => checkPermission(value));
    }
  }
}
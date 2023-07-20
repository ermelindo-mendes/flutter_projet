import 'package:geolocator/geolocator.dart';

class PermissionGps {
  Future<Position>init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error("le gps n'est pas activé");
    }
    else
    {
    LocationPermission permission = await Geolocator.checkPermission();
    return checkPermission(permission);
    }
  }
  Future<Position>checkPermission(LocationPermission permission) {
    switch(permission){
      case LocationPermission.deniedForever: return Future.error("Ne souhaite pas données ses information");
      case  LocationPermission.denied: return Geolocator.requestPermission().then((value) => checkPermission(value));
      case  LocationPermission.unableToDetermine: return Geolocator.requestPermission().then((value) => checkPermission(value));
      case  LocationPermission.whileInUse: return Geolocator.getCurrentPosition();
      case  LocationPermission.always: return Geolocator.getCurrentPosition();
    }
  }
}
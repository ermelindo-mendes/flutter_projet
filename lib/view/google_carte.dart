import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/custom_info_window.dart';
import '../model/my_user.dart';

class CarteGoogle extends StatefulWidget {
  Position location;
  List<MyUser> otherUsers;
   CarteGoogle({super.key, required this.location,  required this.otherUsers});

  @override
  State<CarteGoogle> createState() => _CarteGoogleState();
}

class _CarteGoogleState extends State<CarteGoogle> {
  //variable
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition camera;
  Set<Marker> markers = {};
  FirebaseAuth? auth;
  User? currentUser;


  @override
  void initState() {
    // TODO: implement initState
    camera = CameraPosition(target: LatLng(widget.location.latitude, widget.location.longitude, ),zoom: 14 );
    super.initState();
    auth = FirebaseAuth.instance;
    currentUser = auth!.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: camera,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,

      onMapCreated: (control) async{
          String newStyle = await DefaultAssetBundle.of(context).loadString("lib/mapStyle.json");
          control.setMapStyle(newStyle);
          completer.complete(control);

          // Afficher les positions des autres utilisateurs sur la carte
          for (MyUser user in widget.otherUsers) {
            if (user.id == currentUser?.uid) {
              continue;
            }
            CustomInfoWindow customInfoWindow = CustomInfoWindow(user: user);
            if (user.latitude != null && user.longitude != null) {
              Marker marker = Marker(
                markerId: MarkerId(user.id),
                position: LatLng(user.latitude!, user.longitude!),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      content: CustomInfoWindow(user: user),
                    ),
                  );
                },

                icon: BitmapDescriptor.defaultMarker,
              );
              setState(() {
                markers.add(marker);
              });
            }
          }
      },
      markers: markers.toSet(),

    );
  }
}

/*onTap: () {
// Naviguer vers la page de messagerie lorsque l'utilisateur clique sur l'info-bulle
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const Placeholder() //MessagePage(user: user),
),
);
infoWindowText: CustomInfoWindow(user: user);
}, */

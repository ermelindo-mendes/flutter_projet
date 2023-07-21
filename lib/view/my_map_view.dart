import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';
import 'package:ipssisqy2023/controller/permission_gps.dart';
import 'package:ipssisqy2023/view/google_carte.dart';

import '../model/my_user.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {

  List<MyUser> allUsers = [];
  Position? userPosition;

  @override
  void initState() {

      FirestoreHelper().getAllUsers().then((value) {
        setState(() {
          allUsers = value;
        });
      });
      print(allUsers);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: PermissionGps().init(),
        builder: (context, snap){
          if(snap.data == null) {
            return const Center(child: Text("Aucune donnée "));
          }
          else {
            Position location = snap.data!;
            double latitude = location.latitude;
            double longitude = location.longitude;
            String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

            // Mettez à jour la latitude et la longitude de l'utilisateur dans Firestore
            FirestoreHelper().updateUser(userId, {
              "LATITUDE": latitude,
              "LONGITUDE": longitude,
            });
            return CarteGoogle(location :location, otherUsers: allUsers, );
          }
      }

    );
  }
}

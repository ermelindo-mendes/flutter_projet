import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipssisqy2023/globale.dart';

class MyUser {
  late String id;
  late String mail;
  late String nom;
  late String prenom;
  String? pseudo;
  DateTime? birthday;
  String? avatar;
  Gender genre = Gender.indefini;
  List? favoris;
  double? latitude;
  double? longitude;

  String get fullName {
    return prenom + " " + nom;
  }

  // Constructeur
  MyUser.empty(){
    id = "";
    mail = "";
    nom = "";
    prenom = "";
    latitude = null;
    longitude= null;
  }

  MyUser(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    mail = map["EMAIL"];
    nom = map["NOM"];
    prenom = map["PRENOM"];
    String? provisoirePseudo = map["PSEUDO"];
    favoris = map["FAVORIS"] ?? [];
    latitude = map["LATITUDE"] ?? 0.0;
    longitude = map["LONGITUDE"]?? 0.0;
    if(provisoirePseudo == null) {
      pseudo = "";
    }
    else {
      pseudo = provisoirePseudo;
    }
    Timestamp? birthdaytprovisoire = map["BIRTHDAY"];
    if(birthdaytprovisoire == null){
      birthday = DateTime.now();
    }
    else {
      birthday = birthdaytprovisoire.toDate();
    }
    avatar = map["AVATAR"] ?? defaultImage;
  }
}
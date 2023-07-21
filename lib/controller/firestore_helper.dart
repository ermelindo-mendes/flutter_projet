import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipssisqy2023/model/my_user.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  // Inscription
 Future <MyUser> register(String email, String password, String nom, String prenom) async {
   UserCredential resultat = await auth.createUserWithEmailAndPassword(email: email, password: password);
   String uid = resultat.user?.uid ?? "";
   Map<String,dynamic> map = {
     "EMAIL": email,
     "NOM" :nom,
     "PRENOM":prenom,

   };

   addUser(uid, map);
   return getUser(uid);

  }

  Future<MyUser>getUser(String uid) async {
   DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
   return MyUser(snapshot);
  }

  addUser(String uid, Map<String, dynamic> data){
    cloudUsers.doc(uid).set(data);
  }

  Future<String >stockageData(String ref, String uid, String nameData, Uint8List bytesData) async {
   TaskSnapshot snapshot = await storage.ref("$ref/$uid/$nameData").putData(bytesData);
   String urlData= await snapshot.ref.getDownloadURL();
   return urlData;
  }

  updateUser(String uid, Map<String,dynamic>data){
   cloudUsers.doc(uid).update(data);

  }

  Future<MyUser>connect(String email, String password) async {
   UserCredential resultat = await auth.signInWithEmailAndPassword(email: email, password: password);
   String uid = resultat.user?.uid ?? "";
   return getUser(uid);
  }

  // Récupérer tous les utilisateurs
  Future<List<MyUser>> getAllUsers() async {
    QuerySnapshot snapshot = await cloudUsers.get();
    List<MyUser> users = [];

    for (var document in snapshot.docs) {
      MyUser user = MyUser(document);
      users.add(user);
    }

    return users;
  }
}
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipssisqy2023/model/my_user.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  // Méthode pour ajouter un nouveau message
  static Future<void> addMessage(
      String senderId, String recipientId, Map<String, dynamic> message) async {
    CollectionReference messagesCollection =
    FirebaseFirestore.instance.collection("MESSAGES");

    // Obtenez l'horodatage actuel
    DateTime currentTime = DateTime.now();

    try {
      // Ajoutez le nouveau message avec les champs spécifiés
      await messagesCollection.add({
        'SENDER': senderId,
        'RECIPIENT': recipientId,
        'CONTENT': message['CONTENT'],
        'TIMESTAMP': currentTime,
      });

      print("Le message a été ajouté avec succès !");
    } catch (error) {
      print("Une erreur s'est produite lors de l'ajout du message : $error");
    }
  }

  static Future<List<Map<String, dynamic>>?> getMessages(String userId, String recipientId) async {
    List<Map<String, dynamic>>? messages = [];
    try {
      QuerySnapshot senderQuery = await FirebaseFirestore.instance
          .collection("MESSAGES")
          .where('SENDER', isEqualTo: userId)
          .where('RECIPIENT', isEqualTo: recipientId)
          .orderBy('TIMESTAMP', descending: true)
          .get();

      QuerySnapshot recipientQuery = await FirebaseFirestore.instance
          .collection("MESSAGES")
          .where('SENDER', isEqualTo: recipientId)
          .where('RECIPIENT', isEqualTo: userId)
          .orderBy('TIMESTAMP', descending: true)
          .get();

      messages.addAll(senderQuery.docs.map((doc) => doc.data()).cast<Map<String, dynamic>>());
      messages.addAll(recipientQuery.docs.map((doc) => doc.data()).cast<Map<String, dynamic>>());
      messages.sort((a, b) => b['TIMESTAMP'].compareTo(a['TIMESTAMP']));
    } catch (error) {
      print("Une erreur s'est produite lors de la récupération des messages : $error");
    }
    return messages;
  }

  static Future<List<Map<String, dynamic>>?> getConversations(String currentUserId) async {
    List<Map<String, dynamic>>? conversations = [];
    try {
      // Récupérer les conversations où l'utilisateur est l'expéditeur (SENDER)
      QuerySnapshot senderQuerySnapshot = await FirebaseFirestore.instance
          .collection("MESSAGES")
          .where('SENDER', isEqualTo: currentUserId)
          .orderBy('TIMESTAMP', descending: true)
          .get();

      // Récupérer les conversations où l'utilisateur est le destinataire (RECIPIENT)
      QuerySnapshot recipientQuerySnapshot = await FirebaseFirestore.instance
          .collection("MESSAGES")
          .where('RECIPIENT', isEqualTo: currentUserId)
          .orderBy('TIMESTAMP', descending: true)
          .get();

      // Fusionner les deux listes de conversations
      conversations = senderQuerySnapshot.docs.map((doc) => doc.data()).cast<Map<String, dynamic>>().toList();
      conversations.addAll(recipientQuerySnapshot.docs.map((doc) => doc.data()).cast<Map<String, dynamic>>().toList());

      // Trier la liste des conversations par heure de message décroissante
      conversations.sort((a, b) => b['TIMESTAMP'].compareTo(a['TIMESTAMP']));
    } catch (error) {
      print("Une erreur s'est produite lors de la récupération des conversations : $error");
    }
    return conversations;
  }

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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_helper.dart';
import '../model/my_user.dart';
import 'messaging_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  Map<String, MyUser> recipientUsers = {}; // Utiliser une Map pour stocker les utilisateurs en fonction de leur ID de destinataire

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: FirestoreHelper.getConversations(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Une erreur s'est produite : ${snapshot.error}"));
        } else {
          List<Map<String, dynamic>>? conversations = snapshot.data;
          if (conversations == null || conversations.isEmpty) {
            return const Center(child: Text("Aucune conversation trouvée."));
          } else {
            Map<String, List<Map<String, dynamic>>> groupedConversations = {};

            for (var conversation in conversations) {
              String recipientId = conversation['RECIPIENT'];

              if (groupedConversations.containsKey(recipientId)) {
                groupedConversations[recipientId]!.add(conversation);
              } else {
                groupedConversations[recipientId] = [conversation];
              }
            }

            List<Future<MyUser>> userFutures = groupedConversations.keys.map((recipientId) {
              return FirestoreHelper().getUser(recipientId);
            }).toList();

            return FutureBuilder<List<MyUser>>(
              future: Future.wait(userFutures),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text("Une erreur s'est produite lors de la récupération des utilisateurs : ${userSnapshot.error}"));
                } else {
                  List<MyUser> users = userSnapshot.data ?? [];


                  for (int i = 0; i < groupedConversations.keys.length; i++) {
                    String recipientId = groupedConversations.keys.elementAt(i);
                    recipientUsers[recipientId] = users[i];
                  }


                  return ListView.builder(
                    itemCount: groupedConversations.length,
                    itemBuilder: (context, index) {
                      String recipientId = groupedConversations.keys.elementAt(index);

                      // Vérifier si l'utilisateur connecté est le destinataire de cette conversation
                      if (recipientId == currentUserId) {
                        return Container(); // Si oui, ne pas afficher cette conversation
                      }

                      List<Map<String, dynamic>> messages = groupedConversations[recipientId]!;
                      MyUser recipientUser = recipientUsers[recipientId]!;

                      String recipientName = recipientUser.fullName!;
                      String lastMessageContent = messages.first['CONTENT'] as String;
                      DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(messages.first['TIMESTAMP'].seconds * 1000);

                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Couleur de la bordure (noir)
                              width: 0.5, // Épaisseur de la bordure
                            ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 8,
                              blurRadius: 7,
                              offset: const Offset(0,3),
                            )
                          ]
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(recipientUser.avatar!),
                          ),
                          title: Text(recipientName),
                          subtitle: Text(lastMessageContent),
                          trailing: Text(
                            "${timestamp.hour}:${timestamp.minute}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagingPage(user: recipientUser),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        }
      },
    );
  }
}


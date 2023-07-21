import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import '../controller/firestore_helper.dart';
import '../model/my_user.dart';
import 'my_background.dart';

class MessagingPage extends StatefulWidget {
  final MyUser user;
  const MessagingPage({super.key, required this.user});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  Future<void> getMessages() async {
    List<Map<String, dynamic>>? userMessages =
    await FirestoreHelper.getMessages(currentUserId, widget.user.id);
    setState(() {
      messages = userMessages!;
    });
  }

  Widget _buildMessageItem(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[300],
      child: Text(message),
    );
  }

  void _sendMessage() async {
    String messageContent = _messageController.text;
    if (messageContent.trim().isNotEmpty) {
      Map<String, dynamic> message = {
        'SENDER': currentUserId,
        'RECIPIENT': widget.user.id,
        'CONTENT': messageContent,
        'TIMESTAMP': DateTime.now(),
      };

      // Envoyer le message à l'utilisateur sélectionné
      await FirestoreHelper.addMessage(currentUserId, widget.user.id, message);

      // Mettre à jour la liste des messages pour inclure le nouveau message envoyé
      setState(() {
        messages.insert(0, message); // Insérer le nouveau message en haut de la liste
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.user.fullName,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const MyBackground(),
          const MyBackground2(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Text("Conversation avec ${widget.user.fullName}"),
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: messages
                          .map((message) {
                        bool isSentByMe = message['SENDER'] == currentUserId;
                        String messageContent = message['CONTENT'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ChatBubble(
                            clipper: ChatBubbleClipper9(
                                type: isSentByMe
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble),
                            alignment: isSentByMe
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 4),
                            backGroundColor: isSentByMe
                                ? Colors.blue
                                : Colors.grey[300],
                            child: Text(
                              messageContent,
                              style: TextStyle(
                                  color:
                                  isSentByMe ? Colors.white : Colors.black),
                            ),
                          ),
                        );
                      })
                          .toList()
                          .reversed
                          .toList(), // Inverser l'ordre des messages pour les afficher du plus récent au plus ancien
                    ),
                  ),
                ),
                Form(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          decoration: const InputDecoration(labelText: "Message"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _sendMessage,
                        child: const Text("Envoyer"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

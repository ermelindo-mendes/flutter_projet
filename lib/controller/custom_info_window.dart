import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/my_user.dart';
import '../view/messaging_page.dart';

class CustomInfoWindow extends StatelessWidget {
  final MyUser user;

  CustomInfoWindow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: CircleAvatar(
              radius: 38,
              backgroundImage: NetworkImage(user.avatar ?? ''),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              user.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          TextButton(

            onPressed: () {
              // Naviguer vers la page de messagerie lorsque l'utilisateur clique sur le bouton
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  MessagingPage(user: user), //MessagingPage(user: user),
                ),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.message),
                SizedBox(width: 10),
                Text('Envoyer un message'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

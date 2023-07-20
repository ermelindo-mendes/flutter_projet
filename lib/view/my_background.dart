import 'package:flutter/material.dart';
import 'package:ipssisqy2023/globale.dart';

import '../controller/custom_path.dart';

class MyBackground extends StatefulWidget {
  const MyBackground({super.key});

  @override
  State<MyBackground> createState() => _MyBackgroundState();
}

class _MyBackgroundState extends State<MyBackground> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper:  MyCustomPath(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //color: Colors.black,
        // pour mettre une image a la place de la couleur
        decoration: BoxDecoration(
          image: DecorationImage(
            // AssetImage(chemin vers le ficher sur le repertoire asset) pour image installer sur le projet
              image: NetworkImage(defaultImage),
            // prendre tout le backgraound
            fit: BoxFit.fill
          )
        ),
      ),
    );
  }
}

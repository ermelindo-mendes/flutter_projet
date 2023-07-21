import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';

import '../globale.dart';
import '../model/my_user.dart';
import '../view/favorite_user_view.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  //Variables
  List<MyUser> maListeAmis = [];
  @override
  void initState() {
    // TODO: implement initState
    for(String uid in me.favoris!){
      FirestoreHelper().getUser(uid).then((value) {
        setState(() {
          maListeAmis.add(value);
        });
      });
    }
    super.initState();
  }
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: maListeAmis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemBuilder:(context, index){
          MyUser otherUser = maListeAmis[index];
          return InkWell(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(
                  builder : (context){
                    return  SinglePage(uid: otherUser.id);
                  }

              ));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre et son opacité
                    spreadRadius: 3, // Étendue de l'ombre (plus grande étendue donne un flou plus important)
                    blurRadius: 5, // Rayon du flou (plus grand donne un flou plus étendu)
                    offset: const Offset(0, 3),

                  )],
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(

                child: Column(

                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(otherUser.avatar ?? defaultImage),
                    ),
                    Text(otherUser.fullName)
                  ],
                ),
              ),
            ),
          );
        });
  }
}

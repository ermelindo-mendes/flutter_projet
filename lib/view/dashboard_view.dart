import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/all_utilisateur.dart';
import 'package:ipssisqy2023/controller/mes_favoris.dart';
import 'package:ipssisqy2023/view/my_drawer.dart';

import 'all_conversations.dart';
import 'my_map_view.dart';

class MyDashBoardView extends StatefulWidget {
  const MyDashBoardView({super.key});

  @override
  State<MyDashBoardView> createState() => _MyDashBoardViewState();
}

class _MyDashBoardViewState extends State<MyDashBoardView> {
  //variable
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width*0.75,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey,
        child: const MyDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: bodyPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        //selectedItemColor: Colors.black26,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });

        },
        backgroundColor: Colors.purple,
        iconSize: 30,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black26,),
              label: "Utilisateurs",
              backgroundColor: Colors.white
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.black26),
              label: "Mes amis"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map, color: Colors.black26),
              label: "carte"
          ),
         BottomNavigationBarItem(
              icon: Icon(Icons.message, color: Colors.black26),
              label: "Messages"
          )
        ],
          selectedItemColor: Colors.purple
      ),
    );
  }
  Widget bodyPage() {
    switch(currentIndex){
      case 0 : return const AllUsers();
      case 1 : return const MyFavorites();
      case 2 : return const MyMapView();
      case 3 : return ConversationsPage();
      default: return const Text("Probleme d'affichage");
    }
  }
}



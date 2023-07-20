import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_helper.dart';
import '../globale.dart';
import '../model/my_user.dart';

class SinglePage extends StatefulWidget {
  final String uid;

  const SinglePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<SinglePage> createState() => _SinglePageState();
}



class _SinglePageState extends State<SinglePage> {
  MyUser? user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }



  void getUserData() {
    FirestoreHelper().getUser(widget.uid).then((user) {
      setState(() {
        this.user = user;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    //List friendUIDs = user?.favoris ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: user != null
            ? Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user!.avatar!),
                  ),
                ),
                const SizedBox(height: 50, width: 50),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user!.fullName, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: Text(user!.mail,style: const TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text( ((user?.pseudo== "") || (user?.pseudo == null))?"Pas de pseudo":user!.pseudo!, style: const TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                const ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text( "Amis", style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: user?.favoris?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    if (user!.favoris! == [] || user!.favoris! == null) {
                      print("dans le if----------- ");
                      return const Card(
                          child: Text("Aucun favori"),

                      );
                    } else {
                      String favoriUID = user!.favoris![index];
                      return FutureBuilder(
                        future: FirestoreHelper().getUser(favoriUID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            MyUser? favoriUser = snapshot.data;
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(favoriUser?.avatar ?? defaultImage),
                                  ),
                                  Text(favoriUser!.fullName),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox(); // ou un widget alternatif si la récupération échoue
                          }
                        },
                      );
                    }
                  },
                )



              ],

            ),
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}


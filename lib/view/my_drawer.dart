import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';

import '../globale.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // Variable
  bool isScript = false;
  TextEditingController pseudo = TextEditingController();
  String? nameImages;
  Uint8List? bytesImages;

  //fonction
  popImage(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Souhaitez-vous enregister cette image ?"),
            content: Image.memory(bytesImages!),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Annulation")),
              TextButton(
                  onPressed: (){
                    FirestoreHelper().stockageData("images", me.id, nameImages!, bytesImages!).then((value){
                      setState(() {
                        me.avatar = value;
                      });
                    });
                    Map<String,dynamic> map = {
                      "AVATAR": me.avatar
                    };
                    FirestoreHelper().updateUser(me.id, map);

                    Navigator.pop(context);
                  },
                  child: const Text("Enregistrer"))
            ],
          );
        });
  }
  accesPhoto() async{
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true
    );
    if(resultat != null){
      nameImages = resultat.files.first.name;
      bytesImages = resultat.files.first.bytes;
      popImage();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(

            child: Column(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        accesPhoto();
                      },
                      child: CircleAvatar(

                        radius: 60,
                        backgroundImage: NetworkImage(me.avatar!),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 3,
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: Text(me.mail,style: const TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(me.fullName, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: (isScript)?TextField(
                    controller: pseudo,
                    decoration:  InputDecoration(
                      hintText: me.pseudo ?? ""
                    ),
                  ):Text(me.pseudo ?? "", style: const TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                  trailing: IconButton(
                    icon: Icon((isScript)?Icons.fiber_manual_record:Icons.update),
                    onPressed: (){
                      if(isScript){
                        if(pseudo != null && pseudo.text != "" && pseudo.text != me.pseudo){
                          Map<String,dynamic> map = {
                            "PSEUDO" : pseudo.text
                          };
                          setState(() {
                            me.pseudo = pseudo.text;
                          });
                          FirestoreHelper().updateUser(me.id, map);
                        }

                      }
                      setState(() {
                        isScript= !isScript;
                      });
                    },
                  ),
                )
              ],
            )

        )

    );
  }
}

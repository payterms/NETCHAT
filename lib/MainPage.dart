import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
 }

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> dataChats = [
  ];
    var chatsData ;





@override
void initState() {
   firestore
       .collection("chats")
       // .document("ид конкретного чата")     это нжуно что бы достать сообщения конкретного чата, как пример
       // .collection("messages")

      // .limit(100) - если нужно определенно количество чатов
     // .where("private", isEqualTo: true)  - если нужны только приватные чаты
       .snapshots()
       .listen((event) {
         // тело этого метода срабатает асинхронно при любом изменении в коллекции "chats"  и один раз в самомо начале
     List<Map<String, dynamic>> data = [];
     // если нужны только новые чаты
      event.documentChanges.forEach((element) {
       if (element.type == DocumentChangeType.added) {
         data.add(element.document.data);
        }
      });
     // если нужны изменные  чаты
     event.documentChanges.forEach((element) {
       if (element.type == DocumentChangeType.modified) {
         data.insert(data.indexOf(element.document.data), element.document.data);
       }
     });
     // если нужны удаленные  чаты
     event.documentChanges.forEach((element) {
       if (element.type == DocumentChangeType.removed) {
         data.remove(element.document.data);
       }
     });
      // если нужны все чаты
     event.documents.forEach((documentSnapshot) {
       data.add(documentSnapshot.data);
     });


     setState(() {
       dataChats = data;
     });

   });

  super.initState();
}
 // TODO  нужно создать экран где будет испоьзоваться этот  метод для создания нового чата и нужно использовать TextFormField
 createNewChat (BuildContext context,   Map<String, dynamic> newChat ) {
  firestore.collection("chats").add(newChat).then((value) {
    showDialog(context: context, builder:(BuildContext context) {
      return Dialog(
        child: Center (child:
        Text ("сохранненно успешно"),),
      );
    } );
  });
 }

@override
Widget build(BuildContext context) {

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Наш Чат",
        style: TextStyle(color: Colors.black38),
      ),
      backgroundColor: Colors.greenAccent,
    ),
    body: Center(
      child:  dataChats.isEmpty?
      Text( "идет загрузка"):
      ListView.builder(
        itemCount: dataChats.length,
        itemBuilder: (BuildContext context, int item) {
          return buildInkWell(context, message: dataChats[item]["message"].toString(),
              title: dataChats[item]["message"].toString() , isPrivate: dataChats[item]["private"]
          );
        },

      ),
    ),
  );
}

Widget buildInkWell(BuildContext context,
    {String message = "Последнее сообщение", String title = "", bool isPrivate = false}) {
      if (isPrivate == null)  {
        isPrivate=false;
      }
  return InkWell(
    splashColor: Colors.red,
    child: Container(
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(color: Colors.white10,
          border: Border.all(color: Colors.greenAccent)),
      child:
      Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text(title),
              Text(message)
            ],),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isPrivate? Icon(Icons.lock,) : Container(),
          ),
        ],
      )
      ,),
  );
}
}

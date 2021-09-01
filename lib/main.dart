  
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>("friends");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<String> ? friendsBox;
 

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friendsBox = Hive.box<String>("friends");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title!),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: friendsBox!.listenable(),
              builder: (context, Box<String> friends, _){
                return ListView.separated(
                    itemBuilder: (context, index){
                      final key = friends.keys.toList()[index];
                      final value = friends.get(key);

                      return ListTile(
                        title: Text(value!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                        subtitle: Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      );
                    },
                    separatorBuilder:(context, index) => const Divider(
                      thickness: 2.5,
                      color: Colors.blueGrey,
                      height: 5.0,
                    ),
                    itemCount: friends.keys.toList().length
                );
              },
            )
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                MaterialButton(
                  child: const Text("Add New"),
                  color: Colors.greenAccent,
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (_){
                          return Dialog(

                            child: Container(
                                padding : const EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(
                                           
                                          hintText: 'ID'
                                        ),
                                        controller: _idController,
                                      ) ,

                                      const SizedBox(height:16),

                                      TextField(
                                          decoration: const InputDecoration(
                                           
                                          hintText: 'Name'
                                        ),
                                        controller: _nameController,
                                      ),


                                      const SizedBox(height:16),
                                      MaterialButton(
                                        color: Colors.green,
                                        child : const Text("submit"),

                                        onPressed: (){
                                          final key = _idController.text;
                                          final value = _nameController.text;

                                          friendsBox!.put(key, value);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ]
                                )
                            ),
                          );
                        }
                    );
                  },
                ),

                MaterialButton(
                  child: const Text("Update"),
                  color: Colors.greenAccent,
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (_){
                          return Dialog(
                            child: Container(
                                padding : const EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _idController,
                                      ) ,

                                    const  SizedBox(height:16),

                                      TextField(
                                        controller: _nameController,
                                      ),


                                     const SizedBox(height:16),
                                      MaterialButton(
                                        child : const Text("submit"),

                                        onPressed: (){
                                          final key = _idController.text;
                                          final value = _nameController.text;

                                          friendsBox!.put(key, value);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ]
                                )
                            ),
                          );
                        }
                    );
                  },
                ),

                MaterialButton(
                  child: const Text("Delete"),
                  color: Colors.greenAccent,
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (_){
                          return Dialog(
                            child: Container(
                                padding : const EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _idController,
                                      ) ,


                                    const  SizedBox(height:16),
                                      MaterialButton(
                                        child : const Text("submit"),

                                        onPressed: (){
                                          final key = _idController.text;

                                          friendsBox!.delete(key);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ]
                                )
                            ),
                          );
                        }
                    );
                  },
                ),
              ],
            ),
          )
        ],
      )

    );
  }
}
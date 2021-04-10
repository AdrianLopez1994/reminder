import 'package:flutter/material.dart';
import 'package:reminder/widgets/user_tasks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
        
          appBar: AppBar(
            title: Text("Your list of reminded tasks"),
          ),
          body: new GestureDetector(
            onTap: () {
            
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Center(
            child: UserTasks(),
          )),
        ));
  }
}

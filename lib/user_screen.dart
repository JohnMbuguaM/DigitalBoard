

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'admin_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DIGITAL BOARD',
        theme: ThemeData(
          primaryColor: Color(0xff03833c)
        ),
      home: UserScreen(),
    );
  }
}


CollectionReference usersCollection = FirebaseFirestore.instance.collection('Mwiki Queue');

class UserScreen extends StatelessWidget {

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Seasons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('DIGITAL BOARD',
          style:  TextStyle(
            color: Color(0xfff5d70e),
            fontSize: 24,
            fontWeight: FontWeight.bold
          )


        ),
        backgroundColor: Color(0xff0b9b4c),
        centerTitle: true,

        actions: [
          IconButton(
              icon: const Icon(Icons.person, color: Color(0xfff5d70e),),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>  LoginScreen()),
                );
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collection.orderBy('time', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {

              final record = data[index].data() as Map<String, dynamic>;
              final time = record['time'].toDate();
              final formattedTime = DateFormat('h:mm a').format(time);

              return ListTile(
                  title: SizedBox(
                    height: 80,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.yellow.withOpacity(0.9),
                            width: 1,
                          )
                      ),
                      color: Color(0xffeee399),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xff0b9b4c) ,
                          child: Text('${index + 1}',
                            style: const TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        title: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(record['plate'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono-Bold',
                              )
                              ,),
                            Expanded(
                              child: Text(
                                record['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  fontFamily: 'RobotoMono-Bold',

                                ),
                              ),
                            ),
                            Text(formattedTime),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

            },
          );



        },
      ),
    );

  }
}

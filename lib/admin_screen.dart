import 'package:DigiBoard/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


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
      title: 'Firestore Demo',
      home: AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Seasons');

  Future<void> _addData(String plate, String name) async {
    try {
      await collection.add({
        'plate': plate,
        'name': name,
        'time': FieldValue.serverTimestamp()
      });
      print('Data added successfully');
    } catch (e) {
      print('Error adding data: ');
    }
  }

  Future<void> _showAddDataDialog() async {
    final plateController = TextEditingController();
    final nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ongeze Gari kwa line '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: plateController,
                  decoration: InputDecoration(labelText: 'No_Plate'),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addData(plateController.text, nameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff03833c),
        title: const Text('ADMIN BOARD',

          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xfff8db0a),
            fontFamily: 'RobotoMono-Bold',

          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.switch_account, color: Color(0xfff5d70e),),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserScreen()),
            );
          },
        ),

        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collection.orderBy('time', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
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

              return Dismissible(
                key: Key(data[index].id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  final confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Data'),
                        content: Text('Are you sure gari imejaa?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  return confirmDelete ?? false;
                },
                onDismissed: (_) async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('Seasons')
                        .doc(data[index].id)
                        .delete();

                  } catch (e) {
                    print('Error deleting data: Make sure you are connected');
                  }
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(8),

                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
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
                ),
              );
            },
          );



        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff03833c),
        onPressed: _showAddDataDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

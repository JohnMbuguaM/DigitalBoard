import 'package:flutter/material.dart';
import 'admin_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(


        title: Text('Login Screen'),
          centerTitle: true,
          backgroundColor: Color(0xff0b9b4c)

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Padding(
             padding: EdgeInsets.symmetric(horizontal: 16),
             child: TextField(
               controller: _usernameController,
               decoration: const InputDecoration(
                 hintText: 'Username',
               ),
             ),
            ),
            SizedBox(height: 16),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password'
                ),
            ),
            ),
            SizedBox(height: 16),
            ElevatedButton(



                onPressed: () {
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  if (username == 'admin' && password == 'pesa') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  }else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invalid Credentials'),
                          content: Text('Enter Valid username and password'),
                          actions: [
                            TextButton(

                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Ok'),

                              ),



                          ],
                        );
                      },

                    );
                  }


                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),

              child: Text('Login'),

            ),
          ],
        ),
      ),
    );
  }
}

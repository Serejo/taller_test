/*
Challenge: 
Platform-Adaptive Asynchronous Login Flow

Your task is to build a login flow that simulates a network request. Upon successful login, the user must be navigated to a welcome screen that adapts its appearance to look native on both iOS and Android.

Here are the specific requirements:

1. Build the Login UI:

- Create a screen with two TextFields (username and password) and an ElevatedButton.
2. Simulate the Login Logic:

- Create an async function that simulates a 2-second network delay using Future.delayed.

- The login should succeed if the username is flutter and the password is dev.

- Otherwise, the function should fail by throwing an Exception.
3. Manage the UI State:

- Loading State: When the login button is tapped, show a CircularProgressIndicator and disable the button.

- Error State: If the login fails, hide the loading indicator, re-enable the button, and show a SnackBar with an error message.

- Success State: If the login is successful, navigate the user to the WelcomeScreen.
4. Create a Platform-Adaptive Welcome Screen:

- This screen must detect the host operating system.

- If running on Android, it must display a Material Scaffold with an AppBar and a centered Text widget showing ""Welcome, Android User!"".

- If running on iOS, it must display a Cupertino CupertinoPageScaffold with a CupertinoNavigationBar and a centered Text widget showing ""Welcome, iOS User!"".
To keep things simple:

- You can use a StatefulWidget and setState for the login screen.

- Focus on clean, functional code, not pixel-perfect design.*/

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    _isLoading = true;
    (context as Element).markNeedsBuild();

    try {
      await Future.delayed(Duration(seconds: 2));

      if (username == 'flutter' && password == 'dev') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      _isLoading = false;
      (context).markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _login(context),
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    late String whatIsDevice = Theme.of(context).platform == TargetPlatform.iOS ? "iOS" : "Android";
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Text('Welcome $whatIsDevice User!'),
      ),
    );
  }
}

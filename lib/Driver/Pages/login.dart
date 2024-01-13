import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastewisee/Driver/Pages/forgotpassword.dart';
import 'package:wastewisee/main.dart';

class DLoginPage extends StatefulWidget {
  const DLoginPage({Key? key}) : super(key: key);

  @override
  _DLoginPageState createState() => _DLoginPageState();
}

class _DLoginPageState extends State<DLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true; // Added to keep track of password visibility

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user after successful login
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is not null before proceeding
      if (user != null) {
        // Call a function to create user data in Firestore
        await createUserInFirestore(user.uid, user.email!);

        // Navigate to the next screen or perform other actions
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Invalid email or password. Please try again."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> createUserInFirestore(String userId, String email) async {
    // Create a reference to the user document
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('Driver').doc(userId);

    // Check if the user document exists before creating it
    if (!(await userRef.get()).exists) {
      // Set user data in Firestore
      await userRef.set({
        'email': email,
        // other user details
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password Reset"),
            content: Text(
                "Password reset instructions have been sent to your email."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "Failed to send password reset email. Please try again."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 200,
                  color: Colors.green,
                ),

                const SizedBox(height: 50),

                // Welcome back, you've been missed
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 25),

                // Email Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Password Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscureText, // Use the obscureText variable
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Toggle the obscureText value when the eye symbol is tapped
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Forgot Password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Forgot Password page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Log-in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

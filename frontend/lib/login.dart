import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child:
                        Image.asset("assets/Images/logo.png"),
                  ),
                  Text("Welcome Back.."),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  )
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                        child: Text("Login",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue
                        ),),
                      ),
                    ),
                  )
              
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Beforeloginpage extends StatefulWidget {
  const Beforeloginpage({super.key});

  @override
  State<Beforeloginpage> createState() => _BeforeloginpageState();
}

class _BeforeloginpageState extends State<Beforeloginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Images/Login_image.png"),
            fit: BoxFit.cover,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Locate the perfect ",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold
                        )
                        ),
                        Text("furniture for your ",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold
                        )),
                        Text("home",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold
                        ))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Center(
                
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                    color: const Color.fromARGB(0, 255, 153, 0)
                  ),
                  child: Center(
                    child: Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  )
                  
                  ),
              ),
              SizedBox(height: 20,),
              Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 190, 130, 38)
                  ),
                  child: Center(
                    child: Text("Get Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  ))
            ],
          ),
        ),
      )
    );
  }
}
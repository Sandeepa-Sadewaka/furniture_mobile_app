import 'package:flutter/material.dart';
import 'package:furniture_app/component/CategoryButton.dart';
import 'package:furniture_app/Screens/Items.dart';
import 'package:furniture_app/component/HomeGridView.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _selectedCategory = 'C001'; // Default category


  // Update category selection
  void _updateCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.menu),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home ",
              style: GoogleFonts.outfit(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            Text(
              "Nest",
              style: GoogleFonts.outfit(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child:
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          )
        ],
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 222, 222, 222),
                    hintText: "Search here...",
                    hintStyle: GoogleFonts.outfit(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.only(left: 20),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: const Color.fromARGB(57, 255, 153, 0)),
              child: Row(
                children: [
                  Image(
                    image: AssetImage("assets/Images/chair_1.png"),
                    height: 180,
                    width: 180,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Don't miss out! ",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                          " This sale ends.",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                          " soon.",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 60),
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Shop Now ",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          _updateCategory("C001");
                        },
                        child: WidgetCategoryButton(
                          "Beds",
                        )),
                    GestureDetector(
                        onTap: () {
                          _updateCategory("C002");
                        },
                        child: WidgetCategoryButton(
                          "Sofas",
                        )),
                    GestureDetector(
                        onTap: () {
                          _updateCategory("C003");
                        },
                        child: WidgetCategoryButton(
                          "Chairs",
                        )),
                    GestureDetector(
                        onTap: () {
                          _updateCategory("C004");
                        },
                        child: WidgetCategoryButton(
                          "Tables",
                        ))
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Items()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Show More...    ",
                      style: GoogleFonts.outfit(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                           color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: HomeGridView(category: _selectedCategory),
          ),
        ]),
      ),
    );
  }
}

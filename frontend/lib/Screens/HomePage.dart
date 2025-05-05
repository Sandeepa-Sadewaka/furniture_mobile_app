import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Screens/ItemDetails.dart';
import 'package:furniture_app/component/CategoryButton.dart';
import 'package:furniture_app/Screens/Items.dart';
import 'package:furniture_app/component/Drawermenu.dart';
import 'package:furniture_app/component/HomeGridView.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<dynamic, dynamic> _saleItem = {};
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'C001'; // Default category
  List<dynamic> _searchResults = [];

  // Fetch search results dynamically
  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    List<dynamic> results = await Apiservice().searchProducts(query);
    setState(() {
      _searchResults = results;
    });
  }

  // Update category selection
  void _updateCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawermenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home ",
              style: GoogleFonts.outfit(
                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            Text(
              "Nest",
              style: GoogleFonts.outfit(
                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search Bar with Drop-down List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _searchProducts, // Fetch results as user types
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 222, 222, 222),
                      hintText: "Search here...",
                      hintStyle: GoogleFonts.outfit(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.only(left: 20),
                      suffixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                  ),

                  // Search Results Dropdown
                  if (_searchResults.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      constraints: BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          var item = _searchResults[index];
                          return ListTile(
                            title: Text(item['name']),
                            onTap: () {
                              _searchController.text = item['name'];
                              setState(() {
                                _searchResults = [];
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Itemdetails(item: item),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Sale Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: const Color.fromARGB(57, 255, 153, 0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: Apiservice().getOfferItem(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                            return Center(child: Text('No Offers Available'));
                          }
                          var item = snapshot.data![0];
                          _saleItem = item as Map; 
                          print(item);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              item['image_url'],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't miss out!", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22)),
                          Text("This sale ends soon.", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22)),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Itemdetails(item: _saleItem),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Shop Now ", style: GoogleFonts.outfit(color: Colors.white, fontSize: 17)),
                                        Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(onTap: () => _updateCategory("C001"), child: WidgetCategoryButton("Beds")),
                      GestureDetector(onTap: () => _updateCategory("C002"), child: WidgetCategoryButton("Sofas")),
                      GestureDetector(onTap: () => _updateCategory("C003"), child: WidgetCategoryButton("Chairs")),
                      GestureDetector(onTap: () => _updateCategory("C004"), child: WidgetCategoryButton("Tables")),
                    ],
                  ),
                ),
              ),
            ),

            // "Show More" Button
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Items())),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Show More...    ", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // GridView for Category Items
            Container(
              height: 250,
              child: HomeGridView(category: _selectedCategory),
            ),
          ],
        ),
      ),
    );
  }
}
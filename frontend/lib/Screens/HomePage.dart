import 'package:flutter/material.dart';
import 'package:furniture_app/component/CategoryButton.dart';
import 'package:furniture_app/Screens/Items.dart';
import 'package:furniture_app/Screens/Product.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _selectedCategory = 'Beds'; // Default category

  // Sample data (replace with actual fetching logic)
  final Map<String, List<Product>> _categoryProducts = {
    'Beds': [
      Product(
          name: 'Comfy Bed',
          price: 5000,
          imageUrl: 'https://via.placeholder.com/150?text=Bed1'),
      Product(
          name: 'Wooden Bed',
          price: 7000,
          imageUrl: 'https://via.placeholder.com/150?text=Bed2'),
    ],
    'Sofas': [
      Product(
          name: 'Leather Sofa',
          price: 10000,
          imageUrl: 'https://via.placeholder.com/150?text=Sofa1'),
      Product(
          name: 'Fabric Sofa',
          price: 8000,
          imageUrl: 'https://via.placeholder.com/150?text=Sofa2'),
    ],
    'Chairs': [
      Product(
          name: 'Dining Chair',
          price: 1000,
          imageUrl: 'https://via.placeholder.com/150?text=Chair1'),
      Product(
          name: 'Office Chair',
          price: 2000,
          imageUrl: 'https://via.placeholder.com/150?text=Chair2'),
    ],
    'Tables': [
      Product(
          name: 'Dining Table',
          price: 1500,
          imageUrl: 'https://via.placeholder.com/150?text=Table1'),
      Product(
          name: 'Office Table',
          price: 3000,
          imageUrl: 'https://via.placeholder.com/150?text=Table2'),
    ],
  };

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
                          _updateCategory("Beds");
                        },
                        child: WidgetCategoryButton(
                          "Beds",
                        )),
                    GestureDetector(
                        onTap: () {
                          _updateCategory("Sofas");
                        },
                        child: WidgetCategoryButton(
                          "Sofas",
                        )),
                    GestureDetector(
                        onTap: () {
                          _updateCategory("Chairs");
                        },
                        child: WidgetCategoryButton(
                          "Chairs",
                        )),
                    GestureDetector(
                        onTap: () {
                          _updateCategory("Tables");
                        },
                        child: WidgetCategoryButton(
                          "Tables",
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (_categoryProducts[_selectedCategory]?.length ?? 0) ~/ 2,
              itemBuilder: (context, index) {
                final products = _categoryProducts[_selectedCategory] ?? [];
                final product1 = products[index * 2];
                final product2 = (index * 2 + 1 < products.length)
                    ? products[index * 2 + 1]
                    : null;
                return buildProductCard(product1, product2);
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildProductCard(Product product1, Product? product2) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 270,
        width: double.infinity,
        color: Colors.grey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Items(),
                      ),
                    );
                  },
                  child: Text(
                    "Show more",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Items(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_sharp),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildProductItem(product1),
                if (product2 != null) buildProductItem(product2),
              ],
            ),
          ],
        ),
      ),
    );
  }

 Widget buildProductItem(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 140, width: 140),
            Text(product.name,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Rs. ${product.price}", style: GoogleFonts.outfit(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

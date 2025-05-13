import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/CheckoutPage.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Itemdetails extends StatefulWidget {
  final dynamic item;
  const Itemdetails({required this.item, super.key});

  @override
  State<Itemdetails> createState() => _ItemdetailsState();
}

class _ItemdetailsState extends State<Itemdetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item['image_url'] ?? '';
    final name = widget.item['name'] ?? 'Product Name';
    final description = widget.item['description'] ?? 'No description available';

    // Safely parse price
    final price = double.tryParse(widget.item['price'].toString()) ?? 0.0;
    final productId = widget.item['id']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Product Details",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Product Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity:",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                if (quantity > 1) quantity--;
                              }),
                              icon: const Icon(Icons.remove),
                              color: Colors.orange,
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: const Icon(Icons.add),
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    "Rs. ${price.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final authProvider = Provider.of<Authprovider>(
                        context,
                        listen: false,
                      );
                      final loginMail = authProvider.getMail();

                      if (loginMail.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please login first")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      } else {
                        final cartItem = {
                          "userID": loginMail,
                          "productId": productId,
                          "quantity": quantity,
                        };
                        Apiservice().addToCart(cartItem, context);
                      }
                    },
                    child: Text(
                      "Add to Cart",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final loginMail = Provider.of<Authprovider>(
                        context,
                        listen: false,
                      ).getMail();

                      if (loginMail.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please login first")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              item: widget.item,
                              quantity: quantity,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/ItemDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Cartitems extends StatefulWidget {
  const Cartitems({super.key});

  @override
  State<Cartitems> createState() => _CartitemsState();
}

class _CartitemsState extends State<Cartitems> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    final loginMail = authProvider.getMail();

    if (loginMail.isEmpty) {
      return const Center(
        child: Text('Please login to view your cart'),
      );
    }

    return FutureBuilder<List<dynamic>>(
      future: Apiservice().fetchCartItems(loginMail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading cart: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final cartItems = snapshot.data ?? [];
        if (cartItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Calculate total price
        double total = 0;
        for (final item in cartItems) {
          final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
          final quantity = double.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
          total += price * quantity;
        }
        authProvider.setTotal(total);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final imageUrl = item['image_url'] ?? '';
                  final productName = item['product_name'] ?? 'Product';
                  final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
                  final quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
                  final totalPrice = price * quantity;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Itemdetails(item: item),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      title: Text(
                        productName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rs. ${price.toStringAsFixed(2)} each',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Quantity: $quantity',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final cartId = item['id']?.toString();
                          if (cartId != null) {
                            await Apiservice().deleteCart(cartId as int, context);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rs. ${total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
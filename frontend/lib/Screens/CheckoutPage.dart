import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/StripeService/StripePaymentService.dart';
import 'package:provider/provider.dart'; // Import the Product class

class CheckoutPage extends StatefulWidget {
  final item; // Define the item parameter type
  final int quantity;
  const CheckoutPage({required this.item, required this.quantity, super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double? lastPrice; // Define the lastPrice variable

  @override
  void initState() {
    double price = double.parse(widget.item["price"].toString()) * widget.quantity;
    setState(() {
      lastPrice = price;
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.item["name"],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Image.network(widget.item["image_url"]),
              SizedBox(height: 10),
              Text(
                "Price: Rs. ${lastPrice.toString()}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "Enter Your Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter Your Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(

                  labelText: "Address",
                  hintText: "Enter Your Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Enter Your Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: "City",
                  hintText: "Enter Your City",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _zipCodeController,
                decoration: InputDecoration(
                  labelText: "Zip Code",
                  hintText: "Enter Your Zip Code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your zip code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {

                 late Future<bool> isPayementSuccess =  StripePaymentService.confirmPaymentIntent(lastPrice!);

                  isPayementSuccess.then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment Successful')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment Failed')),
                      );
                    }
                  });
                  


                  String loginMail = Provider.of<Authprovider>(context, listen: false).getMail();

                  print(loginMail);
                  Map<String, dynamic> order = {
                    "user_id": loginMail,
                    'product_id': widget.item["id"],
                    "quantity": widget.quantity,
                    "price": lastPrice,
                    "name": _nameController.text,
                    "address": _addressController.text,
                    "phoneNo": _phoneController.text,
                    "city": _cityController.text,
                    "zipCode": _zipCodeController.text,
                  };
                  if (_formKey.currentState!.validate()) {
                    // Add your checkout logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Payment')),
                    );
                    if (isPayementSuccess == true) {
                      Apiservice apiService = Apiservice();
                      await apiService.checkoutOrder(order, context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Order Placed Successfully')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Proceed to Payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
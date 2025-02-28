import 'package:flutter/material.dart';
import 'package:furniture_app/Screens/Product.dart'; // Import the Product class

class CheckoutPage extends StatefulWidget {
  final  item; // Define the item parameter type
  final int quantity;
  const CheckoutPage({required this.item,required this.quantity,super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();

}

class _CheckoutPageState extends State<CheckoutPage> {

  @override
  void initState() {
    double lastPrice = double.parse(widget.item["price"].toString()) * widget.quantity;

    setState(() {
      lastPrice = lastPrice;
    });
    super.initState();
  }
    double ?lastPrice;

  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
        padding: const EdgeInsets.all(16.0),
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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add your checkout logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Payment')),
                    );
                  }
                },
                child: Text("Proceed to Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/StripeService/StripePaymentService.dart';
import 'package:furniture_app/component/location_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final dynamic item;
  final int quantity;
  const CheckoutPage({required this.item, required this.quantity, super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  late double totalPrice;
  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    totalPrice = double.parse(widget.item["price"]?.toString() ?? '0') * widget.quantity;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _selectLocation(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
          onLocationSelected: (LatLng location, String? address) {
            setState(() {
              _selectedLocation = location;
              _selectedAddress = address;
              if (address != null && _addressController.text.isEmpty) {
                _addressController.text = address;
              }
            });
          },
        ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery location')),
      );
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Processing Payment...')),
    );

    try {
      final isPaymentSuccess = await StripePaymentService.confirmPaymentIntent(totalPrice);

      if (!isPaymentSuccess) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Payment Failed')),
        );
        return;
      }

      final authProvider = Provider.of<Authprovider>(context, listen: false);
      final loginMail = authProvider.getMail();

      final order = {
        "user_id": loginMail,
        'product_id': widget.item["id"]?.toString() ?? '',
        "quantity": widget.quantity,
        "price": totalPrice,
        "name": _nameController.text.trim(),
        "address": _addressController.text.trim(),
        "phoneNo": _phoneController.text.trim(),
        "city": _cityController.text.trim(),
        "zipCode": _zipCodeController.text.trim(),
        "latitude": _selectedLocation!.latitude,
        "longitude": _selectedLocation!.longitude,
      };

      await Apiservice().checkoutOrder(order, context);

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Order Placed Successfully')),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item['image_url'] ?? '';
    final productName = widget.item['name'] ?? 'Product';

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                Text('Quantity: ${widget.quantity}'),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('\$${totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Shipping Info
              Text('Shipping Information', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Full Name', 'Enter your full name'),
              _buildTextField(_addressController, 'Address', 'Enter your address'),
              _buildTextField(_phoneController, 'Phone Number', 'Enter your phone number', keyboardType: TextInputType.phone),
              Row(
                children: [
                  Expanded(child: _buildTextField(_cityController, 'City', 'Enter city')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(_zipCodeController, 'Zip Code', 'Enter zip code', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 20),
              // Location Button
              OutlinedButton.icon(
                onPressed: () => _selectLocation(context),
                icon: Icon(
                  _selectedLocation != null ? Icons.check_circle : Icons.location_on,
                  color: _selectedLocation != null ? Colors.green : Colors.blue,
                ),
                label: Text(
                  _selectedLocation != null ? 'Location Selected' : 'Set Delivery Location',
                  style: TextStyle(color: _selectedLocation != null ? Colors.green : Colors.blue),
                ),
              ),
              if (_selectedAddress != null) ...[
                const SizedBox(height: 8),
                Text('Selected Location:', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                Text(_selectedAddress!, style: GoogleFonts.poppins()),
              ],
              const SizedBox(height: 24),
              // Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _processPayment(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text('Proceed to Payment',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

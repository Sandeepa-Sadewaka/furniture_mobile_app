import 'package:flutter/material.dart';
import 'package:furniture_app/ApiServise/ApiService.dart';
import 'package:furniture_app/Provider/auth_provider.dart';
import 'package:furniture_app/Screens/CheckoutPage.dart';
import 'package:furniture_app/Screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Itemdetails extends StatefulWidget {
  final item;
  const Itemdetails({required this.item, super.key});

  @override
  State<Itemdetails> createState() => _ItemdetailsState();
}

class _ItemdetailsState extends State<Itemdetails> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          "Product Details",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.item['image_url']),
                    fit: BoxFit.cover)),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.item['name'],
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                            icon: Icon(Icons.remove),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(Icons.add),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                widget.item['description'],
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 10),
              Text(
                "Rs. ${widget.item['price']}",
                style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ]),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    String _loginmail =
                        Provider.of<Authprovider>(context, listen: false)
                            .getMail();

                    print(_loginmail);

                    if (_loginmail == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("please login first")));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      Map<String, dynamic> cart = {
                        "userID": _loginmail,
                        "productId": widget.item['id'],
                        "quantity": quantity,
                      };
                      Apiservice().addToCart(cart, context);
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  String loginmail =
                      Provider.of<Authprovider>(context, listen: false).getMail();
                  if (loginmail == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("please login first")));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                                item: widget.item, quantity: quantity)));
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Buy Now",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ))
            ],
          )
        ]),
      ),
    );
  }
}

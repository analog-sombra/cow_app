import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentPage extends HookConsumerWidget {
  final String amount;
  const PaymentPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Payment Options',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: Container(
          height: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\u{20B9} $amount',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // create a alert
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Payment Confirmation",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Payment successful for \u{20B9} $amount with reference ID: 789293462893, Thank you for your purchase.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 14),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  onPressed: () {
                                    context.pop();
                                    context.pop();
                                  },
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });

                    // doneAlert(context, 120, "Successful",
                    //     "Payment successful for \u{20B9} $amount with reference ID: 789293462893, Thank you for your purchase.");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Available Offers Section
            Text(
              'Available Offers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                title: Text('UPTO ₹200 CRED cashba...'),
                trailing: Text(
                  'View all',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Recommended Section
            Text(
              'Recommended',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // _buildPaymentOption('UPI - PayTM'),
            // _buildPaymentOption('UPI - CRED UPI'),
            _buildPaymentOption('UPI - Google Pay'),
            SizedBox(height: 16),

            // All Payment Options Section
            Text(
              'All Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPaymentOption('COD'),
            _buildPaymentOptionWithOffers('UPI', '2 Offers'),
            _buildPaymentOption('Cards'),
            _buildPaymentOption('Netbanking'),
            SizedBox(height: 16),

            // Footer Section
          ]),
        ),
      ),
    );
  }

  // Helper method to build a payment option
  Widget _buildPaymentOption(String title) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  // Helper method to build a payment option with offers
  Widget _buildPaymentOptionWithOffers(String title, String offers) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(offers, style: TextStyle(color: Colors.green)),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}

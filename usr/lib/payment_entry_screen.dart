import 'package:flutter/material.dart';
import 'models.dart';
import 'database_helper.dart';

class PaymentEntryScreen extends StatefulWidget {
  const PaymentEntryScreen({super.key});

  @override
  _PaymentEntryScreenState createState() => _PaymentEntryScreenState();
}

class _PaymentEntryScreenState extends State<PaymentEntryScreen> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _fineReceivedController = TextEditingController();
  final TextEditingController _cashReceivedController = TextEditingController();
  DateTime _date = DateTime.now();

  Future<void> _savePayment() async {
    Payment payment = Payment(
      customerName: _customerController.text,
      fineReceived: double.tryParse(_fineReceivedController.text) ?? 0.0,
      cashReceived: double.tryParse(_cashReceivedController.text) ?? 0.0,
      date: _date,
    );
    await DatabaseHelper.instance.insertPayment(payment);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment recorded')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEET SILVER'),
        leading: const Text('MS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _customerController, decoration: const InputDecoration(labelText: 'Customer Name')),
            TextField(controller: _fineReceivedController, decoration: const InputDecoration(labelText: 'Fine Received (kg)'), keyboardType: TextInputType.number),
            TextField(controller: _cashReceivedController, decoration: const InputDecoration(labelText: 'Cash Received (Rs.)'), keyboardType: TextInputType.number),
            Text('Date: ${_date.toString().split(' ')[0]}'),
            ElevatedButton(onPressed: () async {
              DateTime? picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2101));
              if (picked != null) setState(() => _date = picked);
            }, child: const Text('Pick Date')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _savePayment, child: const Text('Record Payment')),
          ],
        ),
      ),
    );
  }
}
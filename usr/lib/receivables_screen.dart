import 'package:flutter/material.dart';
import 'models.dart';
import 'database_helper.dart';

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({super.key});

  @override
  _ReceivablesScreenState createState() => _ReceivablesScreenState();
}

class _ReceivablesScreenState extends State<ReceivablesScreen> {
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    _customers = await DatabaseHelper.instance.getAllCustomers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEET SILVER'),
        leading: const Text('MS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          Customer customer = _customers[index];
          return ListTile(
            title: Text('${customer.name} - ${customer.city}'),
            subtitle: Text('Fine Due: ${customer.totalFineDue.toStringAsFixed(3)} kg, Cash Due: ${customer.totalCashDue.toStringAsFixed(2)} Rs.'),
          );
        },
      ),
    );
  }
}
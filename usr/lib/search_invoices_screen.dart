import 'package:flutter/material.dart';
import 'models.dart';
import 'database_helper.dart';

class SearchInvoicesScreen extends StatefulWidget {
  const SearchInvoicesScreen({super.key});

  @override
  _SearchInvoicesScreenState createState() => _SearchInvoicesScreenState();
}

class _SearchInvoicesScreenState extends State<SearchInvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Invoice> _invoices = [];
  List<Invoice> _filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    _invoices = await DatabaseHelper.instance.getAllInvoices();
    _filteredInvoices = _invoices;
    setState(() {});
  }

  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInvoices = _invoices.where((invoice) =>
        invoice.customerName.toLowerCase().contains(query) ||
        invoice.city.toLowerCase().contains(query)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEET SILVER'),
        leading: const Text('MS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Search by Customer Name or City'),
              onChanged: (_) => _search(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredInvoices.length,
              itemBuilder: (context, index) {
                Invoice invoice = _filteredInvoices[index];
                return ListTile(
                  title: Text('${invoice.customerName} - ${invoice.city}'),
                  subtitle: Text('Invoice: ${invoice.invoiceNo} - Date: ${invoice.date.toString().split(' ')[0]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditInvoiceScreen(invoice: invoice))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditInvoiceScreen extends StatefulWidget {
  final Invoice invoice;
  const EditInvoiceScreen({super.key, required this.invoice});

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  late Invoice _invoice;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
  }

  Future<void> _updateInvoice() async {
    await DatabaseHelper.instance.updateInvoice(_invoice);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Invoice'),
        actions: [
          IconButton(onPressed: _updateInvoice, icon: const Icon(Icons.save)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: TextEditingController(text: _invoice.customerName), onChanged: (v) => _invoice.customerName = v, decoration: const InputDecoration(labelText: 'Customer Name')),
            TextField(controller: TextEditingController(text: _invoice.city), onChanged: (v) => _invoice.city = v, decoration: const InputDecoration(labelText: 'City')),
            // Add more fields and table for editing
            // For brevity, simplified
          ],
        ),
      ),
    );
  }
}
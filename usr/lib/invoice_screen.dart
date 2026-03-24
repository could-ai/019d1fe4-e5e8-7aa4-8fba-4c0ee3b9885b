import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models.dart';
import 'database_helper.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _invoiceNoController = TextEditingController();
  DateTime _date = DateTime.now();
  List<InvoiceItem> _items = [InvoiceItem(srNo: 1, particulars: '', grossWt: 0.0, bagWt: 0.0, netWt: 0.0, tounch: 0.0, wasteg: 0.0, qty: 0, labour: 0.0, totalFine: 0.0, totalAmount: 0.0)];

  void _addItem() {
    setState(() {
      _items.add(InvoiceItem(srNo: _items.length + 1, particulars: '', grossWt: 0.0, bagWt: 0.0, netWt: 0.0, tounch: 0.0, wasteg: 0.0, qty: 0, labour: 0.0, totalFine: 0.0, totalAmount: 0.0));
    });
  }

  void _calculateTotals() {
    double totalFine = 0.0;
    double totalAmount = 0.0;
    for (var item in _items) {
      item.calculate();
      totalFine += item.totalFine;
      totalAmount += item.totalAmount;
    }
    setState(() {});
  }

  Future<void> _saveInvoice() async {
    Invoice invoice = Invoice(
      customerName: _customerNameController.text,
      city: _cityController.text,
      invoiceNo: _invoiceNoController.text,
      date: _date,
      items: _items,
      totalFine: _items.fold(0.0, (sum, item) => sum + item.totalFine),
      totalAmount: _items.fold(0.0, (sum, item) => sum + item.totalAmount),
    );
    await DatabaseHelper.instance.insertInvoice(invoice);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice saved')));
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('MEET SILVER', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text('Customer: ${_customerNameController.text}'),
              pw.Text('City: ${_cityController.text}'),
              pw.Text('Invoice No: ${_invoiceNoController.text}'),
              pw.Text('Date: ${_date.toString().split(' ')[0]}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Sr.No', 'Particulars', 'Gross Wt.', 'Bag Wt.', 'Net Wt.', 'Tounch (%)', 'Wasteg (%)', 'Qty', 'Labour', 'Total Fine', 'Total Amount'],
                data: _items.map((item) => [
                  item.srNo.toString(),
                  item.particulars,
                  item.grossWt.toStringAsFixed(3),
                  item.bagWt.toStringAsFixed(3),
                  item.netWt.toStringAsFixed(3),
                  item.tounch.toStringAsFixed(2),
                  item.wasteg.toStringAsFixed(2),
                  item.qty.toString(),
                  item.labour.toStringAsFixed(2),
                  item.totalFine.toStringAsFixed(3),
                  item.totalAmount.toStringAsFixed(2),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEET SILVER'),
        leading: const Text('MS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _generatePdf, icon: const Icon(Icons.picture_as_pdf)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _customerNameController, decoration: const InputDecoration(labelText: 'Customer Name')),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
            TextField(controller: _invoiceNoController, decoration: const InputDecoration(labelText: 'Invoice No.')),
            Text('Date: ${_date.toString().split(' ')[0]}'),
            ElevatedButton(onPressed: () async {
              DateTime? picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2101));
              if (picked != null) setState(() => _date = picked);
            }, child: const Text('Pick Date')),
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text('Sr.No')),
                DataColumn(label: Text('Particulars')),
                DataColumn(label: Text('Gross Wt.')),
                DataColumn(label: Text('Bag Wt.')),
                DataColumn(label: Text('Net Wt.')),
                DataColumn(label: Text('Tounch (%)')),
                DataColumn(label: Text('Wasteg (%)')),
                DataColumn(label: Text('Qty')),
                DataColumn(label: Text('Labour')),
                DataColumn(label: Text('Total Fine')),
                DataColumn(label: Text('Total Amount')),
              ],
              rows: _items.map((item) => DataRow(cells: [
                DataCell(Text(item.srNo.toString())),
                DataCell(TextField(onChanged: (v) => item.particulars = v, controller: TextEditingController(text: item.particulars))),
                DataCell(TextField(onChanged: (v) => item.grossWt = double.tryParse(v) ?? 0.0, controller: TextEditingController(text: item.grossWt.toStringAsFixed(3)))),
                DataCell(TextField(onChanged: (v) => item.bagWt = double.tryParse(v) ?? 0.0, controller: TextEditingController(text: item.bagWt.toStringAsFixed(3)))),
                DataCell(Text(item.netWt.toStringAsFixed(3))),
                DataCell(TextField(onChanged: (v) => item.tounch = double.tryParse(v) ?? 0.0, controller: TextEditingController(text: item.tounch.toStringAsFixed(2)))),
                DataCell(TextField(onChanged: (v) => item.wasteg = double.tryParse(v) ?? 0.0, controller: TextEditingController(text: item.wasteg.toStringAsFixed(2)))),
                DataCell(TextField(onChanged: (v) => item.qty = int.tryParse(v) ?? 0, controller: TextEditingController(text: item.qty.toString()))),
                DataCell(TextField(onChanged: (v) => item.labour = double.tryParse(v) ?? 0.0, controller: TextEditingController(text: item.labour.toStringAsFixed(2)))),
                DataCell(Text(item.totalFine.toStringAsFixed(3))),
                DataCell(Text(item.totalAmount.toStringAsFixed(2))),
              ])).toList(),
            ),
            ElevatedButton(onPressed: _addItem, child: const Text('Add Item')),
            ElevatedButton(onPressed: _calculateTotals, child: const Text('Calculate Totals')),
            ElevatedButton(onPressed: _saveInvoice, child: const Text('Save Invoice')),
          ],
        ),
      ),
    );
  }
}
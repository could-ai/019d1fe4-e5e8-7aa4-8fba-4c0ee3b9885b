import 'dart:convert';

class Invoice {
  int? id;
  String customerName;
  String city;
  String invoiceNo;
  DateTime date;
  List<InvoiceItem> items;
  double totalFine;
  double totalAmount;

  Invoice({
    this.id,
    required this.customerName,
    required this.city,
    required this.invoiceNo,
    required this.date,
    required this.items,
    required this.totalFine,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'city': city,
      'invoiceNo': invoiceNo,
      'date': date.toIso8601String(),
      'items': jsonEncode(items.map((e) => e.toMap()).toList()),
      'totalFine': totalFine,
      'totalAmount': totalAmount,
    };
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      customerName: map['customerName'],
      city: map['city'],
      invoiceNo: map['invoiceNo'],
      date: DateTime.parse(map['date']),
      items: (jsonDecode(map['items']) as List).map((e) => InvoiceItem.fromMap(e)).toList(),
      totalFine: map['totalFine'],
      totalAmount: map['totalAmount'],
    );
  }
}

class InvoiceItem {
  int srNo;
  String particulars;
  double grossWt;
  double bagWt;
  double netWt;
  double tounch;
  double wasteg;
  int qty;
  double labour;
  double totalFine;
  double totalAmount;

  InvoiceItem({
    required this.srNo,
    required this.particulars,
    required this.grossWt,
    required this.bagWt,
    required this.netWt,
    required this.tounch,
    required this.wasteg,
    required this.qty,
    required this.labour,
    required this.totalFine,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'srNo': srNo,
      'particulars': particulars,
      'grossWt': grossWt,
      'bagWt': bagWt,
      'netWt': netWt,
      'tounch': tounch,
      'wasteg': wasteg,
      'qty': qty,
      'labour': labour,
      'totalFine': totalFine,
      'totalAmount': totalAmount,
    };
  }

  static InvoiceItem fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      srNo: map['srNo'],
      particulars: map['particulars'],
      grossWt: map['grossWt'],
      bagWt: map['bagWt'],
      netWt: map['netWt'],
      tounch: map['tounch'],
      wasteg: map['wasteg'],
      qty: map['qty'],
      labour: map['labour'],
      totalFine: map['totalFine'],
      totalAmount: map['totalAmount'],
    );
  }

  void calculate() {
    netWt = (grossWt - bagWt);
    totalFine = ((tounch + wasteg) / 100) * netWt;
    totalAmount = qty * labour;
  }
}

class Customer {
  String name;
  String city;
  double totalFineDue;
  double totalCashDue;

  Customer({
    required this.name,
    required this.city,
    this.totalFineDue = 0.0,
    this.totalCashDue = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'totalFineDue': totalFineDue,
      'totalCashDue': totalCashDue,
    };
  }

  static Customer fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'],
      city: map['city'],
      totalFineDue: map['totalFineDue'],
      totalCashDue: map['totalCashDue'],
    );
  }
}

class Payment {
  int? id;
  String customerName;
  double fineReceived;
  double cashReceived;
  DateTime date;

  Payment({
    this.id,
    required this.customerName,
    required this.fineReceived,
    required this.cashReceived,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'fineReceived': fineReceived,
      'cashReceived': cashReceived,
      'date': date.toIso8601String(),
    };
  }

  static Payment fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      customerName: map['customerName'],
      fineReceived: map['fineReceived'],
      cashReceived: map['cashReceived'],
      date: DateTime.parse(map['date']),
    );
  }
}
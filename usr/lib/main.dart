import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEET SILVER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/invoice': (context) => InvoiceScreen(),
        '/search': (context) => SearchInvoicesScreen(),
        '/payment': (context) => PaymentEntryScreen(),
        '/receivables': (context) => ReceivablesScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEET SILVER'),
        leading: const Text('MS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/invoice'),
              child: const Text('Create New Invoice'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/search'),
              child: const Text('Search/Edit Invoices'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/payment'),
              child: const Text('Record Payment'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/receivables'),
              child: const Text('View Receivables'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:expenses/component/chart.dart';
import 'package:expenses/component/transaction_form.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'component/transaction_form.dart';
import 'component/transaction_list.dart';
import 'component/chart.dart';
import 'models/transaction.dart';


main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.lime[300]),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _transactions = [
    
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date){
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(), 
      title: title, 
      value: value, 
      date: date,
      );

      setState(() {
        _transactions.add(newTransaction);
      });

      Navigator.of(context).pop();
  }

  _deleteTransaction(String id){
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id );
    });
  }

_openTransactionFormModal(BuildContext context){
  showModalBottomSheet(
    context: context, 
    builder: (_) {
      return TransactionForm(_addTransaction);
    }
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoais'),
        actions: <Widget>[
          IconButton( 
          icon: Icon(Icons.add),
          onPressed: () =>  _openTransactionFormModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_transactions, _deleteTransaction),
          ], 
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //backgroundColor: Colors.purple,
        onPressed: () =>  _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
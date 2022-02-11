import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/home/my_orders_in_queue.dart';

class BookedDone extends StatefulWidget
{
  OrderClass oc;
  String comes;
  _BookedDone createState ()=> _BookedDone(oc,comes);

  BookedDone(this.oc, this.comes);
}

class _BookedDone extends State<BookedDone>{

  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersInQueue(oc)));
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset("images/created.gif"),
        )
      )
    );
  }

  OrderClass oc;
  String comes;

  _BookedDone(this.oc, this.comes);
}
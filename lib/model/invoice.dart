
import 'package:hair/model/customer.dart';
import 'package:hair/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;
  final String orderid;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.orderid
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final DateTime starttime;
  final double unitPrice;
  final double discount;
  final String serviceid;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.starttime,
    required this.unitPrice,
    required this.discount,
    required this.serviceid
  });
}

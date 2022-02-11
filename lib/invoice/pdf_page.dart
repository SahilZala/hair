import 'package:flutter/material.dart';
import 'package:hair/api/pdf_api.dart';
import 'package:hair/api/pdf_invoice_api.dart';
import 'package:hair/model/customer.dart';
import 'package:hair/model/invoice.dart';
import 'package:hair/model/supplier.dart';
import 'package:hair/widget/button_widget.dart';
import 'package:hair/widget/title_widget.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text("MyApp.title"),
      centerTitle: true,
    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleWidget(
              icon: Icons.picture_as_pdf,
              text: 'Generate Invoice',
            ),
            const SizedBox(height: 48),
            ButtonWidget(
              text: 'Invoice PDF',
              onClicked: () async {
                final date = DateTime.now();
                final dueDate = date.add(Duration(days: 7));

                final invoice = Invoice(
                  supplier: Supplier(
                    name: 'Vendor name',
                    address: 'Salon addreess',
                    paymentInfo: 'non',
                  ),
                  customer: Customer(
                    name: 'User name',
                    address: 'user address',
                  ),
                  info: InvoiceInfo(
                    date: date,
                    dueDate: dueDate,
                    description: 'My description...',
                    number: '${DateTime.now().year}-9999',
                    orderid: "",
                  ),
                  items: [
                    InvoiceItem(
                      description: 'Service name1',
                      date: DateTime.now(),
                      starttime: DateTime.now(),
                      unitPrice: 10.99,
                      discount: 5,
                      serviceid: ""
                    ),

                    InvoiceItem(
                      description: 'Service name2',
                      date: DateTime.now(),
                      starttime: DateTime.now(),
                      unitPrice: 25.00,
                      discount: 3,
                      serviceid: ""
                    ),
                  ],
                );

                final pdfFile = await PdfInvoiceApi.generate(invoice);

                PdfApi.openFile(pdfFile);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
import 'package:flutter/material.dart';
 

import '../../../models/requisitionModel.dart';

class OrderPage extends StatefulWidget {
  OrderPage(
      {super.key,
      required this.orders,
      required this.data,
      required this.companyId,
      required this.department,
      required this.maxAmount,
      required this.email});

  final Requisition data;
  final String email;
  final String department;
  final String companyId;
  final String maxAmount;

  final List<RequisitionLine> orders;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0XFFf9cf64),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
            ),
            title: Text(
              "Order Item",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Container(
              child: ListView.builder(
            itemCount: widget.orders.length,
            itemBuilder: (context, index) => LineOrderItem(
                qty: "${widget.orders[index].oqordered}",
                um: "${widget.orders[index].orderUnit}",
                articleCode: "${widget.orders[index].itemNo}",
                description: "${widget.orders[index].itemDesc}",
                pn: "${widget.orders[index].manItemNo}",
                job: "${widget.orders[index].oeonumber}",
                suggestCost: "${widget.orders[index].extended} XOF"),
          )),
        )
        ;
  }
}

class LineOrderItem extends StatefulWidget {
  LineOrderItem(
      {super.key,
      required this.qty,
      required this.um,
      required this.articleCode,
      required this.description,
      required this.pn,
      required this.job,
      required this.suggestCost});
  final String qty;
  final String um;
  final String articleCode;
  final String description;
  final String pn;
  final String job;
  final String suggestCost;

  @override
  State<LineOrderItem> createState() => _LineOrderItemState();
}

class _LineOrderItemState extends State<LineOrderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Material(
            borderRadius: BorderRadius.circular(5),
            elevation: 2,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.description}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Qty/Qté: ${widget.qty}",
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "U/M: ${widget.um}",
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Code article: ${widget.articleCode}",
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "P/N / Ref.Manuf: ${widget.pn}",
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "JOB/BON TRAV: ${widget.job}",
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ]),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.suggestCost}",
                            style: TextStyle(color: Color(0xFF8359f6)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ]),
                  ],
                ))));
  }
}

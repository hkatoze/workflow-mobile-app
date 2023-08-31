import 'package:flutter/material.dart';
 

class RequisitionItem extends StatelessWidget {
  RequisitionItem(
      {required this.amount, required this.requester, required this.description});

  final String  amount;
  final String requester;
  final String description;

  @override
  Widget build(BuildContext context) {
 
    return  Container(
           
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
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${description}",
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
                                "${requester} Requester/demandeur",
                                style: TextStyle(color: Color(0xFF8359f6)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "XOF ${amount}",
                                overflow: TextOverflow.clip,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF8359f6),
                          size: 25,
                        ),
                      )
                    ],
                  )),
            ));
  }
}

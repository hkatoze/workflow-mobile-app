import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:page_transition/page_transition.dart';

import 'package:workflow/components/buttonWithoutIcon.dart';
import 'package:workflow/services/apiservices.dart';
import 'package:workflow/views/requisitionsPage/components/orderPage.dart';

import '../../../models/requisitionModel.dart';
import '../../mainpage/mainpage.dart';

class RequisitionsDetailsPage extends StatefulWidget {
  RequisitionsDetailsPage(
      {super.key,
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

  @override
  State<RequisitionsDetailsPage> createState() =>
      _RequisitionsDetailsPageState();
}

class _RequisitionsDetailsPageState extends State<RequisitionsDetailsPage> {
  bool _decision = false;
  List<bool> _holds = [];
  int _holdModifiedindex = 0;
  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: _decision ? Colors.red : Color(0xFF8359f6),
                  icon: ButtonWithoutIcon(
                    title: _decision ? "Revoke" : "Approve",
                    bgColor: _decision ? Colors.red : Color(0xFF8359f6),
                    titleColor: Colors.white,
                    onPressed: () {
                      updateRequisitionStatus(_decision ? false : true,
                          widget.companyId, widget.email);
                    },
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: Color(0xFF8359f6),
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("More"),
                      )),
                  label: '',
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Color(0XFFf9cf64),
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightJoined,
                          duration: Duration(milliseconds: 200),
                          childCurrent: RequisitionsDetailsPage(
                            data: widget.data,
                            department: widget.department,
                            companyId: widget.companyId,
                            email: widget.email,
                            maxAmount: widget.maxAmount,
                          ),
                          reverseDuration: Duration(milliseconds: 200),
                          child: Mainpage(
                            page: "requisition",
                          )));
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Purchase Requisition Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DetailsPageSectionTitle(title: "General Information"),
                  GeneralInfoItem(
                    title: "Requester/Demandeur",
                    value: "${widget.data.requestBy}",
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  GeneralInfoItem(
                    title: "Total net amount/Montant net total",
                    value: "XOF ${widget.data.totalAmount}",
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftJoined,
                              duration: Duration(milliseconds: 200),
                              childCurrent: RequisitionsDetailsPage(
                                data: widget.data,
                                department: widget.department,
                                companyId: widget.companyId,
                                maxAmount: widget.maxAmount,
                                email: widget.email,
                              ),
                              reverseDuration: Duration(milliseconds: 200),
                              child: OrderPage(
                                orders: widget.data.lines,
                                data: widget.data,
                                department: widget.department,
                                companyId: widget.companyId,
                                email: widget.email,
                                maxAmount: widget.maxAmount,
                              )));
                    },
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  GeneralInfoItem(
                    title: "Suggest supplier/Fournisseur suggéré",
                    value: "${widget.data.vdname}",
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  GeneralInfoItem(
                    title: "Mode de transport",
                    value: "UNDEFINED",
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  GeneralInfoItem(
                    title: "Required date/Date requise",
                    value: "${widget.data.expArrival}",
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  GeneralInfoItem(
                    title: "Where used/Utilisé sur",
                    value: "${widget.data.reference}",
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  DetailsPageSectionTitle(title: "Workflow"),
                  Container(
                    height: currentHeight * 0.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('${widget.companyId}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // Les données ont été récupérées avec succès
                          final documents = snapshot.data!.docs;

                          // Effectuer le filtrage côté client
                          final filteredDocuments = documents.where((document) {
                            final department = document.get('department');
                            //final int maxAmount = document.get('maxAmount');

                            // Faire les conditions de filtrage souhaitées
                            if (department ==
                                    widget
                                        .department /* &&
                            maxAmount <=
                                int.parse(
                                    widget.maxAmount.replaceAll('.', '')) */
                                ) {
                              return true;
                            }

                            return false;
                          }).toList();

                          return ListView.builder(
                            itemCount: filteredDocuments.length,
                            itemBuilder: (context, index) {
                              final username =
                                  filteredDocuments[index]["username"];
                              final grade = filteredDocuments[index]["grade"];
                              final reqNumber = filteredDocuments[index]
                                  ["requisitions"]["${widget.data.reqNumber}"];

                              final email = filteredDocuments[index].id;

                              if (email == widget.email) {
                                _decision = filteredDocuments[index]
                                        ["requisitions"]
                                    ["${widget.data.reqNumber}"];
                                _holdModifiedindex = index;
                              }

                              _holds.add(filteredDocuments[index]
                                  ["requisitions"]["${widget.data.reqNumber}"]);

                              print(_holds);

                              return WorkflowInfoItem(
                                title: "${username}",
                                isMe: email == widget.email ? true : false,
                                isDone: reqNumber ? true : false,
                                grade: "${grade}",
                                separator: true,
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          // Une erreur s'est produite lors de la récupération des données
                          return Text('Une erreur s\'est produite.');
                        }
                        // Les données sont en cours de chargement
                        return CircularProgressIndicator();
                      },
                    ),
                  )
                ],
              ),
            )),
        onWillPop: () async {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRightJoined,
                  duration: Duration(milliseconds: 200),
                  childCurrent: RequisitionsDetailsPage(
                    data: widget.data,
                    department: widget.department,
                    companyId: widget.companyId,
                    email: widget.email,
                    maxAmount: widget.maxAmount,
                  ),
                  reverseDuration: Duration(milliseconds: 200),
                  child: Mainpage(
                    page: "requisition",
                  )));
          return false;
        });
  }

  bool checkAllTrue(List<bool> holds) {
    for (var value in holds) {
      if (!value) {
        return false;
      }
    }
    return true;
  }

  void updateRequisitionStatus(
      bool newStatus, String companyId, String documentId) async {
    FirebaseFirestore.instance.collection(companyId).doc(documentId).update({
      'requisitions.${widget.data.reqNumber}': newStatus,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "${newStatus ? "Approved" : "Revoked"}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      print('Mise à jour réussie');
    }).catchError((error) {});
    setState(() {
      _decision = newStatus;
      _holds[_holdModifiedindex] = newStatus;
    });

    print(_holds);
    if (checkAllTrue(_holds) && _decision) {
      await updateRequisitionHold(widget.companyId, widget.data.reqNumber, '0');

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.leftToRightJoined,
              duration: Duration(milliseconds: 200),
              childCurrent: RequisitionsDetailsPage(
                data: widget.data,
                department: widget.department,
                companyId: widget.companyId,
                email: widget.email,
                maxAmount: widget.maxAmount,
              ),
              reverseDuration: Duration(milliseconds: 200),
              child: Mainpage(
                page: "requisition",
              )));
    }
  }
}

class GeneralInfoItem extends StatelessWidget {
  const GeneralInfoItem(
      {super.key, required this.title, required this.value, this.onTap});
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap : () {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${title}",
                    style: TextStyle(color: Color(0xFF8359f6)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "${value}",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                ],
              ),
              if (onTap != null)
                Container(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF8359f6),
                    size: 25,
                  ),
                )
            ],
          )
        ]),
      ),
    );
  }
}

class DetailsPageSectionTitle extends StatelessWidget {
  const DetailsPageSectionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Color(0xFF8359f6)),
      child: Text(
        "${title}",
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}

class WorkflowInfoItem extends StatefulWidget {
  WorkflowInfoItem(
      {super.key,
      required this.title,
      this.date,
      this.subtitle,
      required this.isMe,
      required this.isDone,
      required this.grade,
      required this.separator});
  final String title;
  final String? subtitle;
  final String grade;
  final String? date;
  final bool isMe;
  final bool isDone;
  final bool separator;

  @override
  State<WorkflowInfoItem> createState() => _WorkflowInfoItemState();
}

class _WorkflowInfoItemState extends State<WorkflowInfoItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: widget.isMe
              ? Color(0xFF8359f6).withOpacity(0.1)
              : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: widget.isMe
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          widget.isDone ? Icons.check : Icons.arrow_forward,
                          size: 25,
                          color:
                              widget.isDone ? Colors.green : Color(0xFF8359f6),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("")
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.title}",
                          style: TextStyle(
                              color: Color(0xFF8359f6),
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "",
                          style: TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              " ${widget.grade}",
                              style: TextStyle(color: Color(0xFF8359f6)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "",
                              style: TextStyle(color: Color(0xFF8359f6)),
                            ),
                          ]),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 25,
                                        color: widget.isDone
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("")
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.title}",
                                        style: TextStyle(
                                            color: widget.isDone
                                                ? Colors.grey
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${widget.subtitle != null ? widget.subtitle : ""}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                      ),
                      Expanded(child: Container()),
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                " ${widget.grade}",
                                style: TextStyle(color: Color(0xFF8359f6)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${widget.date != null ? widget.date : ""}",
                                style: TextStyle(color: Color(0xFF8359f6)),
                              ),
                            ]),
                      )
                    ]),
        ),
        if (widget.separator)
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
      ],
    );
  }
}

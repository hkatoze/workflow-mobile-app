import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/views/mainpage/mainpage.dart';

import '../../models/requisitionModel.dart';
import '../../services/apiservices.dart';

import '../mainpage/components/requisitionItem.dart';
import 'components/reqquisitionsDetailsPage.dart';

class PurchaseRequisitionPage extends StatefulWidget {
  const PurchaseRequisitionPage(
      {super.key,
      required this.companyId,
      required this.department,
      required this.maxAmount,
      required this.email});
  final String companyId;
  final String department;
  final String maxAmount;
  final String email;
  @override
  State<PurchaseRequisitionPage> createState() =>
      _PurchaseRequisitionPageState();
}

class _PurchaseRequisitionPageState extends State<PurchaseRequisitionPage> {
  void updateRequisitionLength(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("oldRequisitionLength",length );
  }

  @override
  Widget build(BuildContext context) {
 
    return Container(
        child: FutureBuilder<List<Requisition>?>(
      future: getRequisitions(
          widget.companyId, widget.department, widget.maxAmount),
      builder:
          (BuildContext context, AsyncSnapshot<List<Requisition>?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: SpinKitFadingCircle(
                color: Color(0XFFf9cf64),
                size: 53.0,
              ),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data!.length == 0
                  ? Center(
                      child: Text(
                        "Empty",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )
                  : ListView.builder(
                      reverse: false,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        updateRequisitionLength(snapshot.data!.length);
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type:
                                          PageTransitionType.rightToLeftJoined,
                                      duration: Duration(milliseconds: 200),
                                      childCurrent: Mainpage(
                                        page: "requisition",
                                      ),
                                      reverseDuration:
                                          Duration(milliseconds: 200),
                                      child: RequisitionsDetailsPage(
                                        data: snapshot.data![index],
                                        department: widget.department,
                                        companyId: widget.companyId,
                                        email: widget.email,
                                        maxAmount: widget.maxAmount,
                                      )));
                            },
                            child: RequisitionItem(
                              amount: "${snapshot.data![index].totalAmount}",
                              requester: "${snapshot.data![index].requestBy}",
                              description:
                                  "${snapshot.data![index].description}",
                            ));
                      }));
            }
        }
      },
    ));
  }
}

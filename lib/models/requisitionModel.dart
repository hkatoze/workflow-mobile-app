class Requisition {
  final String totalAmount;
  final String rqnhseq;
  final String vdname;
  final String requestBy;
  final String expArrival;
  final String onHold;
  final String description;
  final String reqNumber;
  final String reference;
  final List<RequisitionLine> lines;

  Requisition(
      {required this.rqnhseq,
      required this.vdname,
      required this.requestBy,
      required this.expArrival,
      required this.onHold,
      required this.description,
      required this.reference,
      required this.totalAmount,
      required this.lines,
      required this.reqNumber});

  factory Requisition.fromJson(Map<String, dynamic> json) {
    List<dynamic> linesJson = json['RequisitionLine'] ?? [];
    List<RequisitionLine> lines = linesJson
        .map((lineJson) => RequisitionLine.fromJson(lineJson))
        .toList();
    return Requisition(
      rqnhseq: json['RQNHSEQ'],
      vdname: json['VDNAME'],
      totalAmount: json['TOTALAMOUNT'],
      requestBy: json['REQUESTBY'],
      expArrival: json['EXPARRIVAL'],
      onHold: json['ONHOLD'],
      description: json['DESCRIPTIO'],
      reference: json['REFERENCE'],
      reqNumber: json['RQNNUMBER'],
      lines: lines,
    );
  }
}

class RequisitionLine {
  final String rqnhseq;
  final String rqnlrev;
  final String oqordered;
  final String orderUnit;
  final String itemNo;
  final String expArrival;
  final String itemDesc;
  final String manItemNo;
  final String oeonumber;
  final String extended;

  RequisitionLine({
    required this.rqnhseq,
    required this.rqnlrev,
    required this.oqordered,
    required this.orderUnit,
    required this.itemNo,
    required this.expArrival,
    required this.itemDesc,
    required this.manItemNo,
    required this.oeonumber,
    required this.extended,
  });

  factory RequisitionLine.fromJson(Map<String, dynamic> json) {
    return RequisitionLine(
        rqnhseq: json['RQNHSEQ'],
        rqnlrev: json['RQNLREV'],
        oqordered: json['OQORDERED'],
        orderUnit: json['ORDERUNIT'],
        itemNo: json['ITEMNO'],
        expArrival: json['EXPARRIVAL'],
        itemDesc: json['ITEMDESC'],
        manItemNo: json['MANITEMNO'],
        oeonumber: json['OEONUMBER'],
        extended: json["EXTENDED"]);
  }
}

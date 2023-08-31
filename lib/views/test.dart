import 'package:flutter/material.dart';
import 'dart:convert';



class Requisition {
  final int rqnhseq;
  final String vdname;
  final String requestBy;
  final String expArrival;
  final bool onHold;
  final String description;
  final List<RequisitionLine> lines;

  Requisition({
    required this.rqnhseq,
    required this.vdname,
    required this.requestBy,
    required this.expArrival,
    required this.onHold,
    required this.description,
    required this.lines,
  });

  factory Requisition.fromJson(Map<String, dynamic> json) {
    List<dynamic> linesJson = json['RequisitionLine'] ?? [];
    List<RequisitionLine> lines = linesJson
        .map((lineJson) => RequisitionLine.fromJson(lineJson))
        .toList();
    return Requisition(
      rqnhseq: json['RQNHSEQ'],
      vdname: json['VDNAME'],
      requestBy: json['REQUESTBY'],
      expArrival: json['EXPARRIVAL'],
      onHold: json['ONHOLD'],
      description: json['DESCRIPTIO'],
      lines: lines,
    );
  }
}

class RequisitionLine {
  final int rqnhseq;
  final int rqnlrev;
  final int oqordered;
  final String orderUnit;
  final String itemNo;
  final String expArrival;
  final String itemDesc;
  final String manItemNo;

  RequisitionLine({
    required this.rqnhseq,
    required this.rqnlrev,
    required this.oqordered,
    required this.orderUnit,
    required this.itemNo,
    required this.expArrival,
    required this.itemDesc,
    required this.manItemNo,
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
    );
  }
}

class RequisitionsScreen extends StatefulWidget {
  @override
  _RequisitionsScreenState createState() => _RequisitionsScreenState();
}

class _RequisitionsScreenState extends State<RequisitionsScreen> {
  List<Requisition> _requisitions = [];

  @override
  void initState() {
    super.initState();
    // Ici, vous devez récupérer le JSON contenant les données des réquisitions
    // et le convertir en une liste de Requisition en utilisant json.decode().
    String json = '[{"RQNHSEQ": 1, "VDNAME": "Fournisseur 1", "REQUESTBY": "Utilisateur 1", "EXPARRIVAL": "2023-06-01", "ONHOLD": true, "DESCRIPTIO": "Description 1", "RequisitionLine": [{"RQNHSEQ": 1, "RQNLREV": 1, "OQORDERED": 10, "ORDERUNIT": "Unité 1", "ITEMNO": "Item 1", "EXPARRIVAL": "2023-06-01", "ITEMDESC": "Description de l\'item 1", "MANITEMNO": "Numéro d\'item 1"}, {"RQNHSEQ": 1, "RQNLREV": 2, "OQORDERED": 20, "ORDERUNIT": "Unité 2", "ITEMNO": "Item 2", "EXPARRIVAL": "2023-06-02", "ITEMDESC": "Description de l\'item 2", "MANITEMNO": "Numéro d\'item 2"}]}, {"RQNHSEQ": 2, "VDNAME": "Fournisseur 2", "REQUESTBY": "Utilisateur 2", "EXPARRIVAL": "2023-06-03", "ONHOLD": false, "DESCRIPTIO": "Description 2", "RequisitionLine": [{"RQNHSEQ": 2, "RQNLREV": 1, "OQORDERED": 30, "ORDERUNIT": "Unité 3", "ITEMNO": "Item 3", "EXPARRIVAL": "2023-06-03", "ITEMDESC": "Description de l\'item 3", "MANITEMNO": "Numéro d\'item 3"}]}]';
    List<dynamic> requisitionsJson = jsonDecode(json);
    _requisitions = requisitionsJson
        .map((requisitionJson) => Requisition.fromJson(requisitionJson))
        .toList();
  }

  void _showRequisitionDetails(Requisition requisition) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails de la réquisition'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fournisseur: ${requisition.vdname}'),
              Text('Demandé par: ${requisition.requestBy}'),
              Text('Date d\'arrivée prévue: ${requisition.expArrival}'),
              Text('En attente: ${requisition.onHold}'),
              Text('Description: ${requisition.description}'),
              SizedBox(height: 16),
              Text(
                'Lignes de réquisition (${requisition.lines.length}):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: requisition.lines.length,
                itemBuilder: (BuildContext context, int index) {
                  RequisitionLine requisitionLine = requisition.lines[index];
                  return ListTile(
                    title: Text('Item: ${requisitionLine.itemNo}'),
                    subtitle: Text('Description: ${requisitionLine.itemDesc}'),
                    trailing: Text('Quantité: ${requisitionLine.oqordered}'),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réquisitions'),
      ),
      body: ListView.builder(
        itemCount: _requisitions.length,
        itemBuilder: (BuildContext context, int index) {
          Requisition requisition = _requisitions[index];
          return ListTile(
            title: Text('Réquisition ${requisition.rqnhseq}'),
            subtitle: Text('Fournisseur: ${requisition.vdname}'),
            onTap: () {
              _showRequisitionDetails(requisition);
            },
          );
        },
      ),
    );
  }
}

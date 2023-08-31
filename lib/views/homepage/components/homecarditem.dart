import 'package:flutter/material.dart';

class HomecardItem extends StatefulWidget {
  const HomecardItem(
      {super.key,
      required this.color,
      required this.blocked,
      required this.number,
      required this.wording});
  final Color color;
  final String wording;
  final int number;
  final bool blocked;

  @override
  State<HomecardItem> createState() => _HomecardItemState();
}

class _HomecardItemState extends State<HomecardItem> {
  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    double currentWidth = MediaQuery.of(context).size.width;
    return Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
        elevation: 2,
        child: Container(
          width: currentWidth * 0.39,
          height: currentHeight * 0.18,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Container()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  widget.wording,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
                Container()
              ],
            ),
            SizedBox(
              height: currentHeight * 0.07,
            ),
            if (!widget.blocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    "On hold",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  )),
                  Container(
                    child: Text(
                      "${widget.number}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  )
                ],
              ),
            if (widget.blocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  )),
                  Container(
                    child: Icon(Icons.lock,size: 35,),
                  )
                ],
              ),
          ]),
        ));
  }
}

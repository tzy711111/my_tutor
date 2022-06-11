import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/subject.dart';

class SubjInfo extends StatefulWidget {
  final Subject subject;
  const SubjInfo({Key? key, required this.subject}) : super(key: key);

  @override
  _SubjInfoState createState() => _SubjInfoState();
}

class _SubjInfoState extends State<SubjInfo> {
  late double screenHeight, screenWidth, resWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Subject Details'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: screenHeight / 2.5,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 7, 17, 7),
                child: SizedBox(
                  height: screenHeight / 2.5,
                  child: CachedNetworkImage(
                    width: resWidth / 1.5,
                    fit: BoxFit.cover,
                    imageUrl: CONSTANTS.server +
                        "/mytutor/assets/courses/" +
                        widget.subject.subjectId.toString() +
                        '.png',
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
          ),
          const SizedBox(height: 5),
          Text(
            widget.subject.subjectName.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 18,
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.4),
                      1: FractionColumnWidth(0.6)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      TableRow(children: [
                        const Text('Description',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.subject.subjectDescription.toString(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Price',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(
                            "RM " +
                                double.parse(
                                        widget.subject.subjectPrice.toString())
                                    .toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Sessions',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.subject.subjectSessions.toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Rating',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.subject.subjectRating.toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                    ]),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

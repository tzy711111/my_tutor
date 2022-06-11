import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/tutor.dart';
import 'package:intl/intl.dart';

class TutorInfo extends StatefulWidget {
  final Tutor tutor;
  const TutorInfo({Key? key, required this.tutor}) : super(key: key);

  @override
  _TutorInfoState createState() => _TutorInfoState();
}

class _TutorInfoState extends State<TutorInfo> {
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');

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
        title: const Text('Tutor Details'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              height: screenHeight / 2.5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 7, 17, 7),
                child: SizedBox(
                 height: screenHeight/2.5,
                   child:CachedNetworkImage(
                     width: resWidth/1.5,
                   fit: BoxFit.cover,
                   imageUrl: CONSTANTS.server +
                       "/mytutor/assets/tutors/" +
                       widget.tutor.tutorId.toString() +
                       '.jpg',
                   placeholder: (context, url) =>
                       const LinearProgressIndicator(),
                   errorWidget: (context, url, error) =>
                       const Icon(Icons.error),
                 ),)),),

         const SizedBox(height: 5),

          Text(widget.tutor.tutorName.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.bold),),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 10,
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
                        const Text('Name',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(widget.tutor.tutorName.toString(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Phone No.',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(widget.tutor.tutorPhone.toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Email',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(widget.tutor.tutorEmail.toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Description',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(widget.tutor.tutorDescription.toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ]),
                      TableRow(children: [
                        const Text('Date of Registration',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'League Spartan',
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(
                            df.format(DateTime.parse(
                                widget.tutor.tutorDatereg.toString())),
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

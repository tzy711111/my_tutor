import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/subject.dart';
import '../models/user.dart';

class SubjScreen extends StatefulWidget {
  final User user;
  const SubjScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjScreen> createState() => _SubjScreenState();
}

class _SubjScreenState extends State<SubjScreen> {
  List<Subject> subjlist = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";
  Icon cusIcon = const Icon(Icons.search);
  Widget cusSearch = const Text("Subject");

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
  }

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: cusSearch,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (cusIcon.icon == Icons.search) {
                  cusIcon = const Icon(Icons.clear);
                  cusSearch = _searchBar();
                  searchController.clear();
                } else {
                  cusIcon = const Icon(Icons.search);
                  cusSearch = const Text("Subject");
                  _loadSubjects(1, "");
                }
              });
            },
            icon: cusIcon,
          ),
        ],
      ),
      body: subjlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1.5),
                      children: List.generate(subjlist.length, (index) {
                        return InkWell(
                          splashColor: Colors.blueGrey,
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 25,
                                child: CachedNetworkImage(
                                  width: resWidth,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/courses/" +
                                      subjlist[index].subjectId.toString() +
                                      '.png',
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 28,
                                  child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            child: Text(
                                              truncateWithEllipsis(
                                                30,
                                                subjlist[index]
                                                    .subjectName
                                                    .toString(),
                                              ),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 14,
                                                  fontFamily: 'League Spartan',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.attach_money,
                                                color: Colors.blueGrey,
                                                size: 15.0,
                                              ),
                                              Flexible(
                                                  child: Text(
                                                      "RM " +
                                                          double.parse(subjlist[
                                                                      index]
                                                                  .subjectPrice
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 13,
                                                      )))
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_filled,
                                                color: Colors.blueGrey,
                                                size: 15.0,
                                              ),
                                              Flexible(
                                                  child: Text(
                                                      " " +
                                                          subjlist[index]
                                                              .subjectSessions
                                                              .toString() +
                                                          " sessions",
                                                      style: const TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 13,
                                                      )))
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.reviews,
                                                color: Colors.blueGrey,
                                                size: 15.0,
                                              ),
                                              Flexible(
                                                  child: Text(
                                                      " " +
                                                          subjlist[index]
                                                              .subjectRating
                                                              .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 13,
                                                      )))
                                            ],
                                          ),
                                        ],
                                      )))
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadSubjects(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/loadsubject.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
          subjlist = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjlist.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjlist.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Subject Available";
        subjlist.clear();
        setState(() {});
      }
    });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(15),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            titlePadding: const EdgeInsets.all(0),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    child: Row(children: [
                      const SizedBox(width: 15),
                      const Text(
                        "Subject Details",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 110),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.blueGrey,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ]),
                  ),
                ]),
            content: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: screenHeight / 3.0,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: SizedBox(
                          height: screenHeight / 2.5,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: CachedNetworkImage(
                              width: resWidth / 1.5,
                              fit: BoxFit.cover,
                              imageUrl: CONSTANTS.server +
                                  "/mytutor/assets/courses/" +
                                  subjlist[index].subjectId.toString() +
                                  '.png',
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ))),
                ),
                const SizedBox(height: 5),
                Text(
                  subjlist[index].subjectName.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.4),
                            1: FractionColumnWidth(0.6)
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.top,
                          children: [
                            TableRow(children: [
                              const Text('Description',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  subjlist[index].subjectDescription.toString(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ]),
                            const TableRow(children: [
                              Text(''),
                              Text(''),
                            ]),
                            TableRow(children: [
                              const Text('Price',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "RM " +
                                      double.parse(subjlist[index]
                                              .subjectPrice
                                              .toString())
                                          .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ]),
                            const TableRow(children: [
                              Text(''),
                              Text(''),
                            ]),
                            TableRow(children: [
                              const Text('Sessions',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text(subjlist[index].subjectSessions.toString(),
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ]),
                            const TableRow(children: [
                              Text(''),
                              Text(''),
                            ]),
                            TableRow(children: [
                              const Text('Rating',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text(subjlist[index].subjectRating.toString(),
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'League Spartan',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ]),
                          ]),
                    ),
                  ),
                ),
              ],
            )),
          );
        });
  }

  Widget _searchBar() {
    return TextField(
      textInputAction: TextInputAction.go,
      controller: searchController,
      onChanged: (search) {
        setState(() {
          if (searchController.text.isEmpty) {
            _loadSubjects(1, "");
            subjlist = <Subject>[];
          } else {
            _loadSubjects(1, search);
          }
        });
      },
      decoration: const InputDecoration(
        hintText: "Search by Subject Name...",
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 16),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
    );
  }
}

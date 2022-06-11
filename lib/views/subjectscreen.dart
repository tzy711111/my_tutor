import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/views/subjDetail.dart';
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
  List subjlist = [];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";

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
        title: const Text('Subject'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          )
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
                          onTap: () => {_subjectDetails(index)},
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
                                      subjlist[index]['subject_id'] +
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
                                                subjlist[index]['subject_name']
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
                                                                      [
                                                                      'subject_price']
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
                                                          subjlist[index][
                                                                  'subject_sessions']
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
                                                          subjlist[index][
                                                                  'subject_rating']
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
        return http.Response(
            'Error', 408); 
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        setState(() {
          subjlist = extractdata['subjects'];
          print(subjlist);
        });
      } else {
        setState(() {
          titlecenter = "No Subject Available";
        });
      }
    });
  }

  _subjectDetails(int index) {
    Subject subject = Subject(
      subjectId: subjlist[index]['subject_id'],
      subjectName: subjlist[index]['subject_name'],
      subjectDescription: subjlist[index]['subject_description'],
      subjectPrice: subjlist[index]['subject_price'],
      tutorId: subjlist[index]['tutor_id'],
      subjectSessions: subjlist[index]['subject_sessions'],
      subjectRating: subjlist[index]['subject_rating'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SubjInfo(
                  subject: subject,
                )));
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }
}

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/views/tutorDetail.dart';
import '../constants.dart';
import '../models/tutor.dart';
import '../models/user.dart';

class TutorScreen extends StatefulWidget {
  final User user;
  const TutorScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List ttlist = [];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadTutors(1, search);
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
        title: const Text('Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          )
        ],
      ),
      body: ttlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1.5),
                      children: List.generate(ttlist.length, (index) {
                        return InkWell(
                          splashColor: Colors.blueGrey,
                          onTap: () => {_tutorDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 25,
                                child: CachedNetworkImage(
                                  width: 100,
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/tutors/" +
                                      ttlist[index]['tutor_id'] +
                                      '.jpg',
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Flexible(
                                  flex: 28,
                                  child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            child: Text(
                                              truncateWithEllipsis(
                                                30,
                                                ttlist[index]['tutor_name']
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
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                color: Colors.blueGrey,
                                                size: 15.0,
                                              ),
                                              Flexible(
                                                  child: Text(
                                                      " " +
                                                          ttlist[index][
                                                                  'tutor_phone']
                                                              .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 13,
                                                      )))
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.email,
                                                color: Colors.blueGrey,
                                                size: 15.0,
                                              ),
                                              Flexible(
                                                  child: Text(
                                                      truncateWithEllipsis(
                                                        17,
                                                        " " +
                                                            ttlist[index][
                                                                    'tutor_email']
                                                                .toString(),
                                                      ),
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
                          onPressed: () => {_loadTutors(index + 1, "")},
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

  void _loadTutors(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/loadtutor.php"),
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
          ttlist = extractdata['tutors'];
          print(ttlist);
        });
      } else {
        setState(() {
          titlecenter = "No Tutor Available";
        });
      }
    });
  }

  _tutorDetails(int index) {
    Tutor tutor = Tutor(
      tutorId: ttlist[index]['tutor_id'],
      tutorEmail: ttlist[index]['tutor_email'],
      tutorPhone: ttlist[index]['tutor_phone'],
      tutorName: ttlist[index]['tutor_name'],
      tutorPassword: ttlist[index]['tutor_password'],
      tutorDescription: ttlist[index]['tutor_description'],
      tutorDatereg: ttlist[index]['tutor_datereg'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TutorInfo(
                  tutor: tutor,
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
                      _loadTutors(1, search);
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
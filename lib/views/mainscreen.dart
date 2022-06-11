import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_tutor/views/subjectscreen.dart';
import 'package:my_tutor/views/tutorscreen.dart';
import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> tabOptions;

  @override
  void initState() {
    super.initState();
    tabOptions = [
      SubjScreen(user: widget.user,),
      TutorScreen(user: widget.user),
      //Subscribe(user: widget.user),
      //Favourite(user: widget.user),
      //Subscribe(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabOptions[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.blueGrey,
              iconSize: 20,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.subject_rounded,
                  text: 'Subjects',
                ),
                GButton(
                  icon: Icons.co_present_rounded,
                  text: 'Tutors',
                ),
                GButton(
                  icon: Icons.circle_notifications_rounded,
                  text: 'Subscribe',
                ),
                
                GButton(
                  icon: Icons.favorite_rounded,
                  text: 'Favourite',
                ),
             
                GButton(
                  icon: Icons.person_rounded,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

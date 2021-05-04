import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/qr_scan_scree.dart';
import 'package:chat_app/screens/user_qr_screen.dart';
import 'package:flutter/material.dart';

class ViewSelector extends StatefulWidget {
  @override
  _ViewSelectorState createState() => _ViewSelectorState();
}

class _ViewSelectorState extends State<ViewSelector> {
  final List<Widget> _pages = [QRScanScreen(), UserQR()];
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[500],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fit_screen), label: 'QR Scanner'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.message_outlined), label: 'Chats Screen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code), label: 'User QR Code')
        ],
      ),
    );
  }
}

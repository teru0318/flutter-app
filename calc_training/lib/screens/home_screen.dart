import 'package:flutter/material.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<int>> _menuItems = [];
  int _numberOfQuestions = 0;

  @override
  void initState() {
    super.initState();
    setMenuItems();
    _numberOfQuestions = _menuItems[0].value!;
  }

  void setMenuItems() {
    _menuItems
      ..add(
        DropdownMenuItem(
          value: 10,
          child: Text("10"),
        ),
      )
      ..add(
        DropdownMenuItem(
          value: 20,
          child: Text("20"),
        ),
      )
      ..add(
        DropdownMenuItem(
          value: 30,
          child: Text("30"),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    print("横幅の論理ピクセル：$screenWidth");
    print("縦幅の論理ピクセル：$screenHeight");

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/image_title.png"),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "問題数を押してスタートボタンを押してください",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
              DropdownButton(
                items: _menuItems,
                value: _numberOfQuestions,
                onChanged: (int? selectedValue) => setState(() {
                  _numberOfQuestions = selectedValue!;
                }),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton.icon(
                    onPressed: () => startTestScreen(context),
                    icon: Icon(Icons.skip_next),
                    label: Text("スタート"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  startTestScreen(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(numberOfQuestions: _numberOfQuestions,)));
  }
}

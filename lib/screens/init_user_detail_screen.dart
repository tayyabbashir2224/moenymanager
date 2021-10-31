import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_manager/helpers/db_helper.dart';
import 'package:money_manager/models/user_data_model.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitUserDetailScreen extends StatefulWidget {
  static const String id = 'init_user_detail_screen';
  @override
  _InitUserDetailScreenState createState() => _InitUserDetailScreenState();
}

class _InitUserDetailScreenState extends State<InitUserDetailScreen> {
  String radGroupVal = "Male";
  DateTime finalDate = DateTime.now();
  String userName = "Enter name";
  Uint8List image;

  TextEditingController nameController = TextEditingController();

  DateTime tempDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Fill your details",
          style: TextStyle(
            color: kBackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'done',
        backgroundColor: kBackColor,
        onPressed: () {
          validateUserDetails();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/double_arrow.png"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.60,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 30.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.blue.shade100,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 95.0,
                            height: 95.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: kBackColor,
                                width: 2.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: GestureDetector(
                                onTap: getImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: image == null
                                          ? AssetImage(
                                              "assets/images/male.png",
                                            )
                                          : MemoryImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          myLeading("Name"),
                          myTile(userName, () {
                            showNameDialog();
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          myLeading("Gender"),
                          myTile(radGroupVal, () {
                            showGenderDialog(onChange: () {
                              setState(() {});
                            });
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          myLeading("BirthDate"),
                          myTile(
                              "${finalDate.day}/${finalDate.month}/${finalDate.year}",
                              () {
                            showMyDatePicker();
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter your name"),
          content: TextFormField(
            controller: nameController,
            autofocus: true,
            style: TextStyle(
              color: kBackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  nameController.text = userName;
                });
              },
              child: Text(
                "CANCEL",
                style: TextStyle(
                  color: kBackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    userName = nameController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: kBackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    var img;
    if (pickedFile != null) {
      img = await pickedFile.readAsBytes();
    }
    setState(() {
      if (pickedFile != null) {
        image = img;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No image selected")));
      }
    });
  }

  showMyDatePicker() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (val) {
                    setState(() {
                      tempDate = val;
                    });
                  },
                  initialDateTime: finalDate,
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: finalDate,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      label: Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          finalDate = tempDate;
                          Navigator.of(context).pop();
                        });
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.green,
                      ),
                      label: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showGenderDialog({Function onChange}) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(bottom: 20.0),
              titlePadding: EdgeInsets.all(20.0),
              title: Text("Choose your gender"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: Text("Male"),
                    activeColor: kBackColor,
                    value: "Male",
                    groupValue: radGroupVal,
                    onChanged: (val) {
                      setState(() {
                        radGroupVal = val;
                      });
                      Navigator.of(context).pop();
                      onChange();
                    },
                  ),
                  RadioListTile(
                    value: "Female",
                    groupValue: radGroupVal,
                    activeColor: kBackColor,
                    onChanged: (val) {
                      setState(() {
                        radGroupVal = val;
                      });
                      Navigator.of(context).pop();
                      onChange();
                    },
                    title: Text("Female"),
                  ),
                  RadioListTile(
                    title: Text("Others"),
                    value: "Others",
                    groupValue: radGroupVal,
                    activeColor: kBackColor,
                    onChanged: (val) {
                      setState(() {
                        radGroupVal = val;
                      });
                      Navigator.of(context).pop();
                      onChange();
                    },
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget myTile(String text, Function onTouch) {
    return Expanded(
      child: GestureDetector(
        onTap: onTouch,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: kBackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
              Divider(
                endIndent: 20.0,
              ),
            ],
          ),
        ),
      ),
      flex: 2,
    );
  }

  Widget myLeading(String text) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateUserDetails() async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Select an image")),
      );
    } else if (userName == "Enter name") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name")),
      );
    } else {
      insertUserDetail();
    }
  }

  insertUserDetail() async {
    User u = User(
        name: userName,
        gender: radGroupVal,
        date: finalDate.day,
        month: finalDate.month,
        year: finalDate.year,
        image: image);
    var res = await dbh.insertUserDetail(u);
    if (res > 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userScreenVisited', true);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
    }
  }
}

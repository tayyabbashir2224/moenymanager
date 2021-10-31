import 'package:flutter/material.dart';

class EmptyMsgContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/money_man.png',
              height: 160.0,
              width: 160.0,
            ),
            Text(
              "This list is looking a little bit empty...",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              "Tap on the + button below to add a new income/expense",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

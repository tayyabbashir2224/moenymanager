import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_manager/utils/constants.dart';

Widget getProgressIndicator() {
  return Center(
    child: SpinKitCircle(
      color: kBackColor,
      size: 60.0,
    ),
  );
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/screens/splash_screen.dart';
import 'package:money_manager/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  static const id = "onboarding_screen";
  const OnBoardingScreen({Key key}) : super(key: key);
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoard> onBoards = [
    OnBoard(
      image: "assets/images/click_tracking.png",
      title: "One-click Tracking",
      subtitle: "Track your financial activity just in few seconds..",
    ),
    OnBoard(
      image: "assets/images/intuitive_graph.png",
      title: "Intuitive Graph",
      subtitle: "Know where your money goes..",
    ),
    OnBoard(
      image: "assets/images/easy_to_use.png",
      title: "Easy to Use",
      subtitle: "Operate your income and expense easily..",
    )
  ];

  int curPage = 0;
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () async {
                        if (curPage == 2) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              SplashScreen.id, (route) => false);
                          final prefs = await SharedPreferences.getInstance();
                          print(prefs.getBool('isOnBoardingVisited'));
                          prefs.setBool('isOnBoardingVisited', true);
                          print(prefs.getBool('isOnBoardingVisited'));
                        } else {
                          _pageController.animateToPage(2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      borderRadius: BorderRadius.circular(25.0),
                      splashColor: Colors.blueGrey.withOpacity(0.1),
                      child: Container(
                        height: 50.0,
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          curPage == 2 ? "finish" : "skip",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 9,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: onBoards.length,
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() {
                      curPage = i;
                    });
                  },
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            onBoards[i].image,
                            height: MediaQuery.of(context).size.height * 0.35,
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          AutoSizeText(
                            onBoards[i].title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          AutoSizeText(
                            onBoards[i].subtitle,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoards.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: curPage == index
                                ? kBackColor
                                : Colors.blueGrey.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class OnBoard {
  final String image;
  final String title;
  final String subtitle;
  OnBoard({this.title, this.image, this.subtitle});
}

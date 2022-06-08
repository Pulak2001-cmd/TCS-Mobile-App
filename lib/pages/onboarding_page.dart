import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../widgets/button_widget.dart';
import 'login_page.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          Theme.of(context).primaryColor,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
    ),
    child: SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Realtime Monitoring',
            body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            image: SvgPicture.asset('assets/images/onboarding_page/realtime_monitoring.svg'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Manage your stock',
            body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            image: SvgPicture.asset('assets/images/onboarding_page/manage_your_stock.svg'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Simple UI',
            body: 'For an enhanced experience',
            image: SvgPicture.asset('assets/images/onboarding_page/simple_UI.svg'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Web-based Monitoring',
            body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            footer: ButtonWidget(
              text: 'Start Monitoring',
              onClicked: () => goToHome(context),
            ),
            image: SvgPicture.asset('assets/images/onboarding_page/web_based_monitoring.svg'),
            decoration: getPageDecoration(),
          ),
        ],
        done: Icon(FontAwesomeIcons.solidCircleCheck,
          size: 30,
        color: Colors.blueGrey[500],),
        onDone: () => goToHome(context),
        showSkipButton: true,
        skip: Text('Skip'),
        // onSkip: () => goToHome(context),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: getDotDecoration(),
        // onChange: (index) => print('Page $index selected'),
        globalBackgroundColor: Colors.transparent,
        // skipOrBackFlex: 0,
        // nextFlex: 0,
        // isProgressTap: false,
        // isProgress: false,
        // showNextButton: false,
        // freeze: true,
        // animationDuration: 1000,
      ),
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => LoginPage()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Colors.white,
    activeColor: Colors.blueGrey[500],
    size: Size(8, 8),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
    color: Colors.white),
    bodyTextStyle: TextStyle(fontSize: 20,
    color: Colors.white70),
    bodyPadding: EdgeInsets.all(16),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.transparent,
  );
}
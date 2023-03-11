import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:maxsociety/screen/appintro/app_intro_message.dart';
import 'package:maxsociety/screen/login/login_screen.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';

class AppIntroScreen extends StatefulWidget {
  const AppIntroScreen({super.key});
  static const String routePath = '/';
  @override
  State<AppIntroScreen> createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
    );
  }

  void _onIntroEnd(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routePath);
  }

  Widget _buildImage(String assetName) {
    return SvgPicture.asset('assets/svg/$assetName');
  }

  Widget getBody(BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: textColorLight,
          ),
      bodyTextStyle: Theme.of(context).textTheme.bodyLarge!,
      pageColor: Colors.white,
      titlePadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding * 2,
        vertical: defaultPadding,
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
      imagePadding: const EdgeInsets.only(
        top: defaultPadding * 2,
        left: defaultPadding * 2,
        right: defaultPadding * 2,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding * 2),
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: background,
        allowImplicitScrolling: true,
        autoScrollDuration: 3000,
        pages: [
          PageViewModel(
            title: AppIntoMessage.title1,
            body: AppIntoMessage.desc1,
            image: _buildImage('intro_1.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: AppIntoMessage.title2,
            body: AppIntoMessage.desc2,
            image: _buildImage('intro_2.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: AppIntoMessage.title3,
            body: AppIntoMessage.desc3,
            image: _buildImage('intro_3.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: AppIntoMessage.title4,
            body: AppIntoMessage.desc4,
            image: _buildImage('intro_4.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: AppIntoMessage.title5,
            body: AppIntoMessage.desc5,
            image: _buildImage('intro_5.svg'),
            decoration: pageDecoration,
          ),
        ],
        initialPage: 0,
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        // rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done:
            const Text('Start', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trade_agent_v2/homepage.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late AnimationController _lottieAnimation;

  bool expanded = false;
  final double _bigFontSize = kIsWeb ? 234 : 40;
  final transitionDuration = const Duration(seconds: 1);

  @override
  void initState() {
    _lottieAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() => expanded = true)).then((value) => const Duration(seconds: 1)).then(
          (value) => Future.delayed(const Duration(seconds: 1)).then(
            (value) => _lottieAnimation.forward().then(
                  (value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                          title: 'Trade Agent V2',
                        ),
                      ),
                      (route) => false),
                ),
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'assets/cover.png',
            ),
          ),
        ),
        // color: const Color.fromARGB(252, 153, 208, 218),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedDefaultTextStyle(
              duration: transitionDuration,
              curve: Curves.fastOutSlowIn,
              style: TextStyle(
                color: Colors.black,
                fontSize: !expanded ? _bigFontSize : 40,
                fontWeight: FontWeight.w600,
              ),
              child: const Text(
                'Trade Agent',
              ),
            ),
            AnimatedCrossFade(
              firstCurve: Curves.fastOutSlowIn,
              crossFadeState: !expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: transitionDuration,
              firstChild: Container(),
              secondChild: _logoRemainder(),
              alignment: Alignment.centerLeft,
              sizeCurve: Curves.easeInOut,
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'V2',
          style: TextStyle(
            color: Colors.red,
            fontSize: 50,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

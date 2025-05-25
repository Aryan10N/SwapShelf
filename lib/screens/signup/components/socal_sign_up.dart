import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

import '../../../screens/Signup/components/or_divider.dart';

class SocalSignUp extends StatelessWidget {
  const SocalSignUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrDivider(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'facebook',
              onPressed: () {},
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/facebook.svg",
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'twitter',
              onPressed: () {},
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/twitter.svg",
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'google',
              onPressed: () {},
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/google-plus.svg",
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
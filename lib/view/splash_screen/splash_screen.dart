import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/view/dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavBar(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover, // You can use BoxFit.fill, BoxFit.contain, etc.
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/svg/logo.svg",
              height: 120,
              width: 200,
            ),

            const SizedBox(height: 30), // Adjust the spacing as needed
            const Text(
              '#1 All-in-One POS System by 1S360 \n Fabrics | Tailoring | Ready-made Clothes',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

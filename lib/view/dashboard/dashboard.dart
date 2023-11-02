import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:measurment_app/res/constant/colors.dart';
import 'package:measurment_app/view/delivery/delivery.dart';
import 'package:measurment_app/view/home/home_screen.dart';
import 'package:measurment_app/view/measurment/measurment.dart';
import 'package:measurment_app/view/notification/notifications.dart';
import 'package:measurment_app/view/order/order.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int page = 0;
  List pages = [
    MeasurementScreen(),
    OrderScreen(),
    HomeScreen(),
    DeliveryCalendarScreen(),
    NotificationScreen(),
  ];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: CurvedNavigationBar(
          // iconPadding: 17.0,
          height: 60,
          key: _bottomNavigationKey,
          index: 0,
          items: [
            CurvedNavigationBarItem(
              child: SvgPicture.asset(
                "assets/svg/tape.svg",
                height: 25,
              ),
              // Image.asset(
              //   "assets/images/tape.png",
              //   height: 30,
              // ),
              label: 'Measurement',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            CurvedNavigationBarItem(
              child: SvgPicture.asset(
                "assets/svg/shopping_cart.svg",
                height: 25,
              ),
              //  Image.asset(
              //   "assets/images/shopping_cart.png",
              //   height: 30,
              // ),
              label: 'Orders',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            CurvedNavigationBarItem(
              child: SvgPicture.asset(
                "assets/svg/home.svg",
                height: 25,
              ),

              //  Image.asset(
              //   "assets/images/home.png",
              //   height: 30,
              // ),
              label: 'Home',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            CurvedNavigationBarItem(
              child: Image.asset(
                "assets/images/delivery.png",
                height: 25,
              ),
              label: 'Delivery ',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            CurvedNavigationBarItem(
              child: SvgPicture.asset(
                "assets/svg/notification.svg",
                height: 25,
              ),
              label: 'Notifications',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],

          // height: 55,
          color: AppColors.primaryColor,
          buttonBackgroundColor: AppColors.primaryColor,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: pages[page]);
  }
}

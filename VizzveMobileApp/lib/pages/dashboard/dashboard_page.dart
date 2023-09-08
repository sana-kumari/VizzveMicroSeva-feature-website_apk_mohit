import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vizzve_micro_seva/commons/common.dart';
import 'package:vizzve_micro_seva/constants/constant.dart';
import 'package:vizzve_micro_seva/pages/page.dart';
import 'package:vizzve_micro_seva/routes/app_routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dashboard_controller.dart';

class Dashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async => true,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: controller.isInternetOn ? AppBar(
                leading: InkWell(
                  onTap: () {
                    if (!(_scaffoldKey.currentState?.isDrawerOpen)!) _scaffoldKey
                        .currentState?.openDrawer();
                  },
                  splashColor: AppColors.ThemeColor[AppColors.ColorGray],
                  child: Image.asset(ImageConst.imageMenu),
                ),
                flexibleSpace: SafeArea(
                  child: Hero(
                    child: Image.asset(
                      ImageConst.titleLogo,
                      height: 160,
                    ),
                    tag: LabelConst.tagApplyLoan,
                  ),
                ),
              ) : null,
              drawer: Drawer(
                elevation: 16,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 26),
                      child: Image.asset(ImageConst.titleLogo),
                    ),
                    Flexible(
                      flex: 9,
                      fit: FlexFit.loose,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.ThemeColor[AppColors.ColorCommon]),
                        padding: EdgeInsets.all(20),
                        child: SafeArea(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ReusableListItem(
                                  text: "FAQs",
                                  onPressed: () async {
                                      var res = await Get.toNamed(AppRoutes.FAQ);
                                      if(res == null || res == true){
                                        Get.back();
                                      }
                                  }),
                              kIsWeb ? Text("", style: TextStyle(fontSize: 0),) : ReusableListItem(
                                  text: "Refer & Earn",
                                  onPressed: () async {
                                    var res = await Get.toNamed(AppRoutes.REFER);
                                    if(res == null || res == true){
                                      Get.back();
                                    }
                                  }),
                              ReusableListItem(
                                  text: "Credit Rewards Program",
                                  onPressed: () async {
                                    var res = await Get.toNamed(AppRoutes.CREDIT);
                                    if(res == null || res == true){
                                      Get.back();
                                    }
                                  }),
                              ReusableListItem(
                                  text: "Customer Support",
                                  onPressed: () async {
                                      var res =  await Get.toNamed(AppRoutes.SUPPORT);
                                      if(res == null || res == true){
                                        Get.back();
                                      }
                                  }),
                              ReusableListItem(
                                  text: "About Us",
                                  onPressed: () async {
                                      var res = await Get.toNamed(AppRoutes.PAGE);
                                          if(res == null || res == true) {
                                            Get.back();
                                          }
                                  }),
                              ReusableListItem(
                                  text: "Terms and Conditions",
                                  onPressed: () async {
                                    var res = await Get.toNamed(AppRoutes.TERMPAGE);
                                    if(res == null || res == true) {
                                      Get.back();
                                    }
                                  }),
                              ReusableListItem(
                                  text: "Return and Refund",
                                  onPressed: () async {
                                    var res = await Get.toNamed(AppRoutes.REFUNDPAGE);
                                    if(res == null || res == true) {
                                      Get.back();
                                    }
                                  }),
                              ReusableListItem(
                                  text: "Privacy Policy",
                                  onPressed: () async {
                                    var res = await Get.toNamed(AppRoutes.PRIVATEPAGE);
                                    if(res == null || res == true) {
                                      Get.back();
                                    }
                                  }),
                              ReusableListItem(
                                  text: "Logout",
                                  onPressed: () {
                                      controller.logout().then((value) {
                                        if (value) {
                                          Get.off(WelcomePage());
                                        }
                                      });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.ThemeColor[AppColors.ColorCommon]),
                        //padding: EdgeInsets.all(20),
                        child: Center(child: Text("Made in India",
                          style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              body: controller.isInternetOn ? kIsWeb ? Center(
                child: Container(
                  width: 800,
                  child: SafeArea(
                    child: controller.tabIndex == 0 ? HomePage() : controller.tabIndex == 1 ? MyLoanPage() : controller.tabIndex == 2 ? ProfilePage() : NotificationPage(),
                    // child: controller.tabIndex == 0 ? MyLoanPage() : controller.tabIndex == 1 ? ProfilePage() : NotificationPage(),
                  ),
                ),
              ) : SafeArea(
                child: controller.tabIndex == 0 ? HomePage() : controller.tabIndex == 1 ? MyLoanPage() : controller.tabIndex == 2 ? ProfilePage() : NotificationPage(),
                // child: controller.tabIndex == 0 ? MyLoanPage() : controller.tabIndex == 1 ? ProfilePage() : NotificationPage(),
              ) : CheckNetwork(),
              bottomNavigationBar: controller.isInternetOn ? Padding(
                padding: MediaQuery.of(context).size.width > 1024 ? EdgeInsets.symmetric(horizontal: 280) : EdgeInsets.symmetric(horizontal: 0),
                child: BottomNavigationBar(
                  unselectedItemColor: AppColors.ThemeColor[AppColors.ColorDarkBlack],
                  selectedItemColor: AppColors.ThemeColor[AppColors.ColorCommon],
                  onTap: controller.changeTabIndex,
                  currentIndex: controller.tabIndex,
                  showSelectedLabels: true,
                  selectedFontSize: 13,
                  unselectedFontSize: 11,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  items: kIsWeb ? [
                    _bottomNavigationBarItem(
                      icon: Image.asset(
                        ImageConst.imageCurrency,
                        height: 32,
                        width: 32,
                      ),
                      label: 'Get Loan',
                    ),
                     _bottomNavigationBarItem(
                      icon: Image.asset(
                        ImageConst.imageMyLoan,
                        height: 32,
                        width: 32,
                      ),
                      label: 'My Loans',
                    )
                  ] : [
                    _bottomNavigationBarItem(
                      icon: Image.asset(
                        ImageConst.imageCurrency,
                        height: 32,
                        width: 32,
                      ),
                      label: 'Get Loan',
                    ),
                    _bottomNavigationBarItem(
                      icon: Image.asset(
                        ImageConst.imageMyLoan,
                        height: 32,
                        width: 32,
                      ),
                      label: 'My Loans',
                    ),
                    _bottomNavigationBarItem(
                      icon: Image.asset(
                        ImageConst.imageProfile,
                        height: 32,
                        width: 32,
                      ),
                      label: 'Profile',
                    ),
                    _bottomNavigationBarItem(
                      icon: Image.asset(
                        ImageConst.imageNotification,
                        height: 32,
                        width: 32,
                      ),
                      label: 'Notification',
                    ),
                  ],
                ),
              ) : null,
            ),
          );
        }
    );
  }

  _bottomNavigationBarItem({required Image icon, required String label}) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}

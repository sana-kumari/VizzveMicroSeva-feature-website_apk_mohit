import 'package:vizzve_micro_seva/commons/common.dart';
import 'package:vizzve_micro_seva/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vizzve_micro_seva/pages/welcome/welcome_controller.dart';
import 'package:vizzve_micro_seva/routes/app_routes.dart';
import '../page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
        init: WelcomeController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isInternetOn
                ? Center(
                  child: Container(
                      width: kIsWeb ? 500 : MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      color: AppColors.ThemeColor[AppColors.ColorAccent],
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Flexible(
                            fit: kIsWeb ? FlexFit.loose : FlexFit.tight,
                            flex: 3,
                            child: Padding(
                              padding: kIsWeb ? EdgeInsets.only(top: 100) : EdgeInsets.only(top: 0),
                              child: Image.asset(
                                ImageConst.imageLogo,
                                width: 350,
                                height: 350,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: kIsWeb ? EdgeInsets.only(left: 20, right: 20, top: 80) : EdgeInsets.symmetric(horizontal: 20),
                              child: ReusableButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.SIGNIN);
                                },
                                child: Text(
                                  "Login In",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ),
                          kIsWeb ? Text("") : SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: ReusableButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.START);
                                },
                                child: Text(
                                  "New Registration",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                )
                : CheckNetwork(),
          );
        });
  }
}

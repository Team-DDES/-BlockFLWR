import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter_web/main.dart';
import 'package:flutter_web/mainpage/did_vc.dart';
import 'package:flutter_web/mainpage/join.dart';
import 'package:flutter_web/mainpage/organization_main_page.dart';
import 'package:flutter_web/mainpage/organization_register_page.dart';
import 'package:flutter_web/mainpage/participate_detail_page.dart';
import 'package:flutter_web/mainpage/participate_main_page.dart';
import 'package:flutter_web/mainpage/participate_search_page.dart';
import 'marketplace/marketplace_main_page.dart';

class Routes {
  static final router = FluroRouter();

  static var firstScreen = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const MyApp();
  });

  static var joinHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const Join(
      title: 'Join Page',
    );
    //return SecondPage(data: params["data"][0]);
  });
  static var didvcHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const DidVc(
      title: 'did_vc Page',
    );
  });
  static var participateMainPageHandler = Handler(handlerFunc:
      (BuildContext? context, Map<String, dynamic> pamain_pagerams) {
    return ParticipateMainPage(
      title: "participate_main_page",
    );
  });
  static var participateSearchPageHandler = Handler(handlerFunc:
      (BuildContext? context, Map<String, dynamic> pamain_pagerams) {
    return ParticipateSearchPage(
      title: "participate_search_page",
    );
  });
  static var participateDetailPageHandler = Handler(handlerFunc:
      (BuildContext? context, Map<String, dynamic> pamain_pagerams) {
    return ParticipateDetailPage(
      title: "participate_detail_page",
    );
  });
  static var organizationMainPageHandler = Handler(handlerFunc:
      (BuildContext? context, Map<String, dynamic> pamain_pagerams) {
    return OrganizationMainPage(
      title: "organization_main_page",
    );
  });
  static var organizationRegisterPageHandler = Handler(handlerFunc:
      (BuildContext? context, Map<String, dynamic> pamain_pagerams) {
    return OrganizationRegisterPage(
      title: "organization_register_page",
    );
  });
  static var marketplaceMainPageHandler = Handler(handlerFunc:
      (BuildContext? context, Map<String, dynamic> pamain_pagerams) {
    return MarketplaceMainPage(
      title: "marketplace_main_page",
    );
  });


  static dynamic defineRoutes() {
    router.define("main",
        handler: firstScreen, transitionType: TransitionType.fadeIn);
    router.define("join",
        handler: joinHandler, transitionType: TransitionType.fadeIn);
    router.define("did_vc",
        handler: didvcHandler, transitionType: TransitionType.fadeIn);
    router.define("participate_main_page",
        handler: participateMainPageHandler,
        transitionType: TransitionType.fadeIn);
    router.define("participate_search_page",
        handler: participateSearchPageHandler,
        transitionType: TransitionType.fadeIn);
    router.define("participate_detail_page",
        handler: participateDetailPageHandler,
        transitionType: TransitionType.fadeIn);
    router.define("marketplace_main_page",
        handler: marketplaceMainPageHandler,
        transitionType: TransitionType.fadeIn);
    router.define("organization_main_page",
        handler: organizationMainPageHandler,
        transitionType: TransitionType.fadeIn);
    router.define("organization_register_page",
        handler: organizationRegisterPageHandler,
        transitionType: TransitionType.fadeIn);
    //router.define("second/:data", handler: placeHandler,transitionType: TransitionType.inFromLeft);
  }
}

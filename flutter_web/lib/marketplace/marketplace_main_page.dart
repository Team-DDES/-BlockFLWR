import 'package:flutter/material.dart';
import 'package:flutter_web/data/bcfl.dart';

import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/marketplace/base_marketplace_page.dart';
import 'package:flutter_web/utils/color_category.dart';

class MarketplaceMainPage extends StatefulWidget {
  MarketplaceMainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MarketplaceMainPage> createState() => MarketplaceMainPageState();
}

class MarketplaceMainPageState extends State<MarketplaceMainPage>{
  var userName = dummyUser.userName;
  var userType = dummyUser.userType;
  var isConnect = dummyUser.isConnect;

  final capacity = 3;
  final List<BCFL> filteredData = <BCFL>[];
  final List<BCFL> displayData = <BCFL>[];

  int selectPage = 1;

  @override
  Widget build(BuildContext context) {
    return BaseMarketplaceView(isConnect: isConnect, child: childWidget());
  }

  Widget childWidget(){
    return Column(
      children: [
        Card(
            color: Colors.transparent,
            elevation: 4.0,
            shadowColor: Colors.transparent,
            child: Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: TextField(
                onChanged: (value) {
                  filterData(value);
                  setState(() {
                    selectPage = 1;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search more FL models...',
                  hintStyle: TextStyle(color: notSelectTextColor, fontSize: 20),
                  //TODO search Icon 수정
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                  //prefixIcon: const Image(fit: BoxFit.cover, image: AssetImage("assets/images/main_search_icon.png")),
                ),
              ),
            )),
        initWidget(),
      ],
    );
  }

  Widget initWidget(){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: introOrgCard()
          ),
          Spacer(),
          Expanded(
            flex: 3,
            child: introOrgCard()
          ),
          Spacer(),
          Expanded(
            flex: 3,
            child: introOrgCard()
          ),
        ],
      ),
    );
  }

  Widget introOrgCard(){
    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: didElementColor,
      ),
    );
  }

  void filterData(String query) {
    filteredData.clear();
    if (query.isNotEmpty) {
      for (var item in dummyBCFLList) {
        if (item.containKeyword(query)) {
          filteredData.add(item);
        }
      }
    } else {
      filteredData.addAll(dummyBCFLList);
    }
    setState(() {});
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/bcfl.dart';

import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/manager/wallet_connection_manager.dart';
import 'package:flutter_web/marketplace/base_marketplace_page.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class MarketplaceMainPage extends StatefulWidget {
  MarketplaceMainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MarketplaceMainPage> createState() => MarketplaceMainPageState();
}

class MarketplaceMainPageState extends State<MarketplaceMainPage> {
  var userName = dummyUser.userData.userName;
  var userType = dummyUser.userData.userType;
  var currentQuery = "";

  final maxCapacity = 3;
  final List<BCFL> filteredData = <BCFL>[];
  final List<BCFL> displayData = <BCFL>[];

  int selectPage = 1;

  @override
  Widget build(BuildContext context) {
    return BaseMarketplaceView(child: childWidget());
  }

  Widget childWidget() {
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
                  currentQuery = value;
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
        isInitState() ? initWidget() : searchResultWidget(createDisplayData(filteredData ,selectPage)),
      ],
    );
  }
  bool isInitState(){
    if(filteredData.isEmpty){
      if(currentQuery.length == 0)
        return true;
      else
        return false;
    }
    return false;
  }


  Widget initWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 3, child: introOrgCard(dummyBCFLList[0], false)),
          Spacer(),
          Expanded(flex: 3, child: introOrgCard(dummyBCFLList[1], false)),
          Spacer(),
          Expanded(flex: 3, child: introRecentCard()),
        ],
      ),
    );
  }

  Widget searchResultWidget(List<BCFL> bcflList) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black,
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bcflList.isEmpty
                  ? dummyContainer
                  : Expanded(flex: 3, child: introOrgCard(bcflList[0], true)),

              Spacer(),
              bcflList.length >= 2
                  ? Expanded(flex: 3, child: introOrgCard(bcflList[1], true))
                  : dummyContainer,
              Spacer(),
              bcflList.length >= 3
                  ? Expanded(flex: 3, child: introOrgCard(bcflList[2], true))
                  : dummyContainer,
            ],
          ),
          pagerList(bcflList)
        ],
      )
    );
  }

  Widget introOrgCard(BCFL data, bool isSearch) {
    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: isSearch ? didElementColor : Colors.black,
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  data.owner,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: textWhite,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/example_org_1.png")),
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  data.intro,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: textWhite,
                    decoration: TextDecoration.none,
                  ),
                )),
            const Spacer(),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      StyleResources.commonBtnCallback),
                ),
                child: TextUtils.defaultTextWithSizeAlignWeight(
                    'BUY', 20, TextAlign.center, FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introRecentCard() {
    List<BCFL> recentFL = dummyBCFLList.sublist(2, 6);
    return Container(
        width: 300,
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.white, width: 3),
          color: Colors.white60,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: TextUtils.defaultTextWithSizeColor('Recents', 20,
                  color: textBlack),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
              child: Column(
                children: [
                  for (BCFL data in recentFL) recentElement(data),
                ],
              ),
            )
          ],
        ));
  }

  Widget recentElement(BCFL data) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.maxFinite,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: TextUtils.defaultTextWithSizeAlignWeight(
                data.owner, 20, TextAlign.left, FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              data.taskName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                color: textBlack,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget pagerList(List<BCFL> listData) {
    var pagerNeed = listData.length % maxCapacity == 0
        ? listData.length ~/ maxCapacity
        : listData.length ~/ maxCapacity + 1;
    if(listData.isEmpty) pagerNeed = 1;
    List<bool> pagerSelect = List.filled(pagerNeed, false);
    pagerSelect[selectPage - 1] = true;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.center,
      height: 20,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(screenWidth / 3, 0, screenWidth / 3, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: StyleResources.pagerBtnStyle,
            onPressed: () {
              if (selectPage > 1) {
                setState(() {
                  selectPage = selectPage - 1;
                });
              }
            },
            child: Icon(Icons.chevron_left_rounded, color: Colors.white),
          ),
          for (int i = 1; i <= pagerNeed; i++)
            ElevatedButton(
              style: pagerSelect[i - 1]
                  ? StyleResources.pagerSelectBtnStyle
                  : StyleResources.pagerNormalBtnStyle,
              onPressed: () {
                setState(() {
                  selectPage = i;
                });
              },
              child: Text(
                i.toString(),
                style: StyleResources.pagerTextBtnNormalStyle,
              ),
            ),
          ElevatedButton(
            style: StyleResources.pagerBtnStyle,
            onPressed: () {
              if (selectPage < pagerNeed) {
                setState(() {
                  selectPage = selectPage + 1;
                });
              }
            },
            child: Icon(Icons.chevron_right_rounded, color: Colors.white),
          )
        ],
      ),
    );
  }

  List<BCFL> createDisplayData(List<BCFL> targetData, int page) {
    List<BCFL> displayData = <BCFL>[];
    int start = (maxCapacity * (page - 1)).toInt();
    int limit;
    if (targetData.length < start + maxCapacity.toInt()) {
      limit = targetData.length;
    } else {
      limit = maxCapacity.toInt() + start;
    }
    for (int i = start; i < limit; i++) {
      displayData.add(targetData[i]);
    }
    return displayData;
  }

  void filterData(String query) {
    filteredData.clear();
    if (query.isNotEmpty) {
      for (var item in dummyBCFLList) {
        if (item.containKeyword(query)) {
          filteredData.add(item);
        }
      }
    }
  }

  Widget dummyContainer = Container(
    width: 300,
    height: 500,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: didElementColor,
    ),
  );
}

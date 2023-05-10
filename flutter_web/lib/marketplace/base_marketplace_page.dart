import 'package:flutter/material.dart';

import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/text_utils.dart';

class BaseMarketplaceView extends StatefulWidget {
  var child;
  var isConnect;

  BaseMarketplaceView({super.key, required this.child, required this.isConnect});

  @override
  State<BaseMarketplaceView> createState() => BaseMarketplaceViewState();
}

class BaseMarketplaceViewState extends State<BaseMarketplaceView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: welcomeBackgroundColor,
          image: const DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/marketplace_background.png')),
        ),
        margin: EdgeInsets.fromLTRB(10, 10, 30, 30),
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 30),
          child: Column(
            children: [
              topBar(context),
              widget.child,
            ],
          ),
        ));
  }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: TextUtils.defaultTextWithSizeColor("BCFL MarketPlace", 25, color: textWhite),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: TextUtils.defaultTextWithSize("Wallet connection", 17),
              ),
              Container(
                height: 45,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(10),
                child: Image(
                    image: widget.isConnect
                        ? const AssetImage('assets/images/main_wallet_connection.png')
                        : const AssetImage(
                            'assets/images/main_wallet_notconnect.png')),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: const Divider(
            height: 2,
            thickness: 1,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

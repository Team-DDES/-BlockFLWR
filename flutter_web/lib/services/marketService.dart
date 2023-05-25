import 'dart:convert';

import 'package:flutter_web/utils/http_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:collection';

import 'package:flutter_web/data/market.dart';

class MarketService{
  final http.Client _httpClient = http.Client();
  final String baseUrl;

  MarketService({this.baseUrl = BASE_URL});

  Future<List<Market>> getNFTList() async{
    final url = Uri.parse('$baseUrl/market/');
    print("Market Start :: ");
    final response = await _httpClient.get(
      url, headers: {'Content-Type': 'application/json'},
    );
    print("Market Pass 1 :: ");
    if (response.statusCode == 200) {
      List<Market> marketResponse = <Market>[];
      jsonDecode(response.body).forEach((market) {
        marketResponse.add(Market.fromJson(market));
      });
      return marketResponse;
    } else {
      throw Exception('Failed to get Marketplace Data');
    }
  }
}
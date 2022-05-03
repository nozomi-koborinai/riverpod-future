import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/data/postal_code.dart';

StateProvider<String> postalCodeProvider = StateProvider((ref) => '');

FutureProvider<PostalCode> apiProvider = FutureProvider((ref) async {
  final postalcode = ref.watch(postalCodeProvider.state).state;
  if (postalcode.length != 7) {
    throw Exception('Postal Code must be 7 charactors');
  }

  // 123-4567
  final upper = postalcode.substring(0, 3); //123
  final lower = postalcode.substring(3); //4567

  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';
  final apiUri = Uri.parse(apiUrl);
  http.Response response = await http.get(apiUri);

  //レスポンスコードが200なら処理成功なのでそれ以外なら弾く
  if (response.statusCode != 200) {
    throw Exception('No postal code：$postalcode');
  }

  var jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});

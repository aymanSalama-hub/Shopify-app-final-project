import 'dart:developer';

import 'package:bisky_shop/core/services/api_endpoints.dart';
import 'package:bisky_shop/core/services/dio_provider2.dart';
import 'package:bisky_shop/features/home/data/model/product_response/product_response.dart';

class HomeRepo {
  static Future<List<ProductResponse3?>?> getFeature2() async {
    try {
      var res = await DioProvider2.get(endpoint: ApiEndpoints2.product2);

      if (res.statusCode == 200) {
        List<ProductResponse3>? listData = [];

        for (var i in res.data) {
          listData.add(ProductResponse3.fromJson(i));
        }
        print(
          "=======================================================================",
        );
        print(listData.length);
        return listData;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }


}

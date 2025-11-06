import 'dart:developer';

import 'package:bisky_shop/core/services/api_endpoints.dart';
import 'package:bisky_shop/core/services/dio_provider.dart';
import 'package:bisky_shop/features/home/data/model/product_response/product_response.dart';

class HomeRepo {
  static Future<List<ProductResponse?>?> getFeature() async {
    try {
      var res = await DioProvider.get(endpoint: ApiEndpoints.product);

      if (res.statusCode == 200) {
        List<ProductResponse>? listData = [];

        for (var i in res.data) {
          listData.add(ProductResponse.fromJson(i));
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

  // static Future<SliderResponse?> getSlider() async {
  //   try {
  //     var res = await DioProvider.get(endpoint: ApiEndpoints.sliders);

  //     if (res.statusCode == 200) {
  //       return SliderResponse.fromJson(res.data);
  //     } else {
  //       return null;
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //     return null;
  //   }
  // }
}

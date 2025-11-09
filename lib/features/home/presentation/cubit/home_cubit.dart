import 'package:bisky_shop/features/home/data/model/product_response/product_response.dart';
import 'package:bisky_shop/features/home/data/repo/home_repo.dart';
import 'package:bisky_shop/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

  List<ProductResponse3?>? productList3 = [
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
  ];

  List<ProductResponse3?>? mostPopularList = [
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
  ];

  List<ProductResponse3?>? mostPopularTop5 = [
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
  ];

  List<ProductResponse3?>? featuredList5 = [
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
  ];
  List<ProductResponse3?>? sliderProducts = [
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
    ProductResponse3(),
  ];
  fechHomeData() async {
    emit(LoadingHomeSTate());

    try {
      productList3 = await HomeRepo.getFeature2();
      if (productList3 != null && productList3!.isNotEmpty) {
        sliderProducts = productList3!
            .where((p) => p!.image != null && p.image!.isNotEmpty)
            .take(5)
            .toList();

        mostPopularList = productList3!.where((p) => p!.rating != null).toList()
          ..sort((a, b) => b!.rating!.rate!.compareTo(a!.rating!.rate!));
        mostPopularTop5 = mostPopularList!.length >= 5
            ? mostPopularList!.sublist(0, 5)
            : mostPopularList;

        featuredList5 = mostPopularList!.length >= 10
            ? mostPopularList!.sublist(5, 10)
            : mostPopularList!.skip(5).toList();
        emit(SuccessHomeState());
      } else {
        emit(ErrorHomeState(message: "Error "));
      }
    } catch (e) {
      emit(ErrorHomeState(message: e.toString()));
    }
  }
}

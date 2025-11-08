import 'package:bisky_shop/features/home/data/model/product_response/product_response.dart';
import 'package:bisky_shop/features/home/data/repo/home_repo.dart';
import 'package:bisky_shop/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

  List<ProductResponse3?>? productList = [
    ProductResponse3(),
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
    ProductResponse3(),
  ];

  fechHomeData() async {
    emit(LoadingHomeSTate());
    try {
      productList = await HomeRepo.getFeature2();
      if (productList != null && productList!.isNotEmpty) {
        // here slider list //
        if (productList!.length > 12) {
          sliderProducts = productList!.sublist(7, 12);
        }

        emit(SuccessHomeState());
      } else {
        emit(ErrorHomeState(message: "Error "));
      }
    } catch (e) {
      emit(ErrorHomeState(message: e.toString()));
    }
  }
}

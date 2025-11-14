// lib/features/favorites/presentation/cubit/favorites_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:Shopify/features/home/data/repo/home_repo.dart';
import '../../../details/presentation/widgets/shared_pref_favourite_icon.dart';
import '../../../home/data/model/product_response/product_response.dart';
import 'favourite_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final allProducts = await HomeRepo.getFeature2();

      // جلب ids المحفوظة في SharedPreferences
      final favIds = await FavoriteManager.getAllFavoriteIds();

      // فلترة المنتجات حسب ids
      final favProducts = <ProductResponse3>[];
      for (var p in allProducts ?? []) {
        if (p != null && p.id != null && favIds.contains(p.id.toString())) {
          favProducts.add(p);
        }
      }

      emit(FavoritesLoaded(favProducts));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> removeFavorite(String productId) async {
    await FavoriteManager.removeFavorite(productId);
    await loadFavorites();
  }
}

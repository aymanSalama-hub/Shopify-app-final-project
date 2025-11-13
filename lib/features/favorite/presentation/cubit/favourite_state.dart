import '../../../home/data/model/product_response/product_response.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<ProductResponse3> products;
  const FavoritesLoaded(this.products);
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}

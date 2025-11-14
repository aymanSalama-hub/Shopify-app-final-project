import 'package:Shopify/features/details/presentation/cubit/addCart_state.dart';
import 'package:Shopify/features/home/data/model/product_response/product_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddcartCubit extends Cubit<AddCartState> {
  AddcartCubit() : super(AddCartInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> addProductToCart(ProductResponse3 product) async {
    emit(AddCartLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(product.id.toString())
            .set({
              'id': product.id.toString(),
              'title': product.title,
              'brand': product.category,
              'price': product.price,
              'quantity': 1,
              'imageUrl': product.image,
            });
        emit(AddCartSuccess('product added to cart'));
      } else {
        emit(AddCartFailure('User not authenticated'));
      }
    } catch (e) {
      emit(AddCartFailure(e.toString()));
    }
  }

  Future<void> removeProductFromCart(String productId) async {
    emit(AddCartLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(productId)
            .delete();

        emit(AddCartSuccess('product removed from cart'));
      } else {
        emit(AddCartFailure('User not authenticated'));
      }
    } catch (e) {
      emit(AddCartFailure(e.toString()));
    }
  }

  Future<void> toggleProductInCart(
    String productId,
    ProductResponse3 product,
  ) async {
    emit(AddCartLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final cartDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(productId)
            .get();
        if (cartDoc.exists) {
          await removeProductFromCart(productId);
        } else {
          await addProductToCart(product);
        }
      } else {
        emit(AddCartFailure('User not authenticated'));
      }
      emit(AddCartSuccess('Cart updated successfully'));
    } catch (e) {
      emit(AddCartFailure(e.toString()));
    }
  }
}

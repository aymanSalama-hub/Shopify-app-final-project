class AddCartState {}

class AddCartInitial extends AddCartState {}

class AddCartLoading extends AddCartState {}
class AddCartSuccess extends AddCartState {
  final String message;
  AddCartSuccess(this.message);
}
class AddCartFailure extends AddCartState {
  final String error;
  AddCartFailure(this.error);
}
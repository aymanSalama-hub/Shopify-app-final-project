class CardOrderState {}

class CardOrderInitial extends CardOrderState {}

class CardOrderLoading extends CardOrderState {}
class CardOrderLoaded extends CardOrderState {}
/// Error state with an optional message to surface to the UI
class CardOrderError extends CardOrderState {
	final String message;
	CardOrderError([this.message = 'An error occurred. Please try again.']);
}
class IncreaseQuantitySuccess extends CardOrderState {}
part of 'view_cart_bloc.dart';

@immutable
sealed class ViewCartEvent {}

class ViewCartFetchCartItems extends ViewCartEvent {}

class OrderNow extends ViewCartEvent {
  final String customersId;

  OrderNow({required this.customersId});
}

class CustomerFetchingEvent extends ViewCartEvent {}

class ViewCartRemoveCartItem extends ViewCartEvent {
  final String id;
  final String products_id;
  final String quantity;

  ViewCartRemoveCartItem(this.id, this.products_id, this.quantity);
}

class UpdateItemQuantityFromCart extends ViewCartEvent {
  final String id;
  final String products_id;
  final String quantity;

  UpdateItemQuantityFromCart(this.id, this.products_id, this.quantity);
}

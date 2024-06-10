part of 'create_new_order_bloc.dart';

@immutable
sealed class CreateNewOrderEvent {}

class CustomerFetchingEvent extends CreateNewOrderEvent {}

class ShowAllBrandForTheUser extends CreateNewOrderEvent {}

class ProductListById extends CreateNewOrderEvent {
  final String brandId;
  final String productTypeId;
  ProductListById({required this.brandId, required this.productTypeId});
}

class AddToCart extends CreateNewOrderEvent {
  final String productId;
  final int quantity;
  AddToCart({required this.productId, required this.quantity});
}

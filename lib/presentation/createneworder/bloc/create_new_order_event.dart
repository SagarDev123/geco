part of 'create_new_order_bloc.dart';

@immutable
sealed class CreateNewOrderEvent {}

class CustomerFetchingEvent extends CreateNewOrderEvent {}

class ShowAllBrandForTheUser extends CreateNewOrderEvent {
  final String brandName;

  ShowAllBrandForTheUser(this.brandName);
}

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

class ProductType extends CreateNewOrderEvent {}

class AddToCartEvent extends CreateNewOrderEvent {
  final String productId;
  final String quanity;

  AddToCartEvent({required this.productId, required this.quanity});
}

class ProductListFetching extends CreateNewOrderEvent {
  final String productTypeId;
  final List<String> brandId;

  ProductListFetching(this.productTypeId, this.brandId);
}

part of 'create_new_order_bloc.dart';

@immutable
sealed class CreateNewOrderState {}

final class CreateNewOrderInitial extends CreateNewOrderState {}

class CreateNewOrderApiLoading extends CreateNewOrderState {}

class CustomerListFetched extends CreateNewOrderState {
  final List<Datum> customers;
  CustomerListFetched({required this.customers});
}

class CustomerNameListFetched extends CreateNewOrderState {
  final List<String> customerNames;
  CustomerNameListFetched({required this.customerNames});
}

class CreateNewOrderFailure extends CreateNewOrderState {
  final String error;
  CreateNewOrderFailure({required this.error});
}

class BrandFetchingCompleted extends CreateNewOrderState {
  final List<BrandData> brand;
  BrandFetchingCompleted({required this.brand});
}

class BrandNameListFetchingCompleted extends CreateNewOrderState {
  final List<String> brandNameList;
  BrandNameListFetchingCompleted({required this.brandNameList});
}

class ProductTypeListFetchingCompleted extends CreateNewOrderState {
  final List<ProductTypeDatum> productTypeDatum;
  ProductTypeListFetchingCompleted({required this.productTypeDatum});
}

class ProductTypeNameListFetchingCompleted extends CreateNewOrderState {
  final List<String> productNameList;
  ProductTypeNameListFetchingCompleted({required this.productNameList});
}

class ProductListFetched extends CreateNewOrderState {
  final List<ProductModelData> products;

  ProductListFetched({required this.products});
}

class AddToCartSuccess extends CreateNewOrderState {}

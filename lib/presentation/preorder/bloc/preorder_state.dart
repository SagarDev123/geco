part of 'preorder_bloc.dart';

@immutable
sealed class PreorderState {}

final class PreorderInitial extends PreorderState {}

class PreOrderApiLoading extends PreorderState {}

class ReOrderIsSuccess extends PreorderState {}

class CustomerNameListFetched extends PreorderState {
  final List<String> customerNames;
  CustomerNameListFetched({required this.customerNames});
}

class PreOrderListFetched extends PreorderState {
  final List<ProductList> preOrderList;
  final SalesData salesData;
  PreOrderListFetched({required this.preOrderList, required this.salesData});
}

class CustomerListFetched extends PreorderState {
  final List<Datum> customers;
  CustomerListFetched({required this.customers});
}

class PreviousOrderFailure extends PreorderState {
  final String error;

  PreviousOrderFailure({
    required this.error,
  });
}

class BrandListFetchCompleted extends PreorderState {
  final List<BrandData> datum;
  BrandListFetchCompleted({required this.datum});
}

class BrandNameListFetchCompleted extends PreorderState {
  final List<String> brandNameList;
  BrandNameListFetchCompleted({required this.brandNameList});
}

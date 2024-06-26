part of 'view_cart_bloc.dart';

@immutable
sealed class ViewCartState {}

final class ViewCartInitial extends ViewCartState {}

class ViewCartApiLoading extends ViewCartState {}

class ViewCartFailure extends ViewCartState {
  final String error;

  ViewCartFailure({
    required this.error,
  });
}

class CustomerNameListFetched extends ViewCartState {
  final List<String> customerNames;
  CustomerNameListFetched({required this.customerNames});
}

class CustomerListFetched extends ViewCartState {
  final List<Datum> customers;
  CustomerListFetched({required this.customers});
}

class ViewCartItemFetchSuccess extends ViewCartState {
  final List<CartList> cartList;
  final String taxable;
  final String gstamount;
  final String total;
  final double totalToPay;

  ViewCartItemFetchSuccess(
      {required this.cartList,
      required this.total,
      required this.taxable,
      required this.gstamount,
      required this.totalToPay});
}

class ViewCartItemUpdated extends ViewCartState {}

class OnOrderNowCompleted extends ViewCartState {}

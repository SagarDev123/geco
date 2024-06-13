part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

class CustomersApiLoading extends CustomerState {}

class CustomerListFetched extends CustomerState {
  final List<Datum> customers;
  CustomerListFetched({required this.customers});
}

class CustomerFailure extends CustomerState {
  final String error;
  CustomerFailure({required this.error});
}

class AddCustomerSuccess extends CustomerState {}

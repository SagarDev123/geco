part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

class CustomerListFetching extends CustomerEvent {
  final String name;
  CustomerListFetching(this.name);
}

class AddNewCustomer extends CustomerEvent {
  final String name;
  final String storeName;
  final String mobileNumber;
  final String gstNumber;
  final String address;

  AddNewCustomer(this.name, this.storeName, this.mobileNumber, this.gstNumber,
      this.address);
}

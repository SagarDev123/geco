part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

class CustomerListFetching extends CustomerEvent {}

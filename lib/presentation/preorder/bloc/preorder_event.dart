part of 'preorder_bloc.dart';

@immutable
sealed class PreorderEvent {}

class CustomerFetchingEvent extends PreorderEvent {}

class PreviousOrder extends PreorderEvent {
  final String customerId;
  final String brandId;
  PreviousOrder({required this.customerId, required this.brandId});
}

class ReOrder extends PreorderEvent {
  final String salesId;
  ReOrder({required this.salesId});
}

class BrandList extends PreorderEvent {}

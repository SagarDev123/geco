import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/model/itemsincartmodel.dart';
import 'package:geco/repository/viewcart_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/addtocartsuccessmodel.dart';
import '../../../data/model/customer.dart';
import '../../../data/remote/exceptions.dart';
import '../../../utils/constants.dart';
import '../../../utils/sharedpreferencehelper.dart';

part 'view_cart_event.dart';
part 'view_cart_state.dart';

class ViewCartBloc extends Bloc<ViewCartEvent, ViewCartState> {
  ViewCartRepository viewCartRepository;
  ViewCartBloc({required this.viewCartRepository}) : super(ViewCartInitial()) {
    on<ViewCartEvent>((event, emit) {});
    on<ViewCartFetchCartItems>(
      (event, emit) async {
        try {
          emit(ViewCartApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          ItemsInCartModel itemsInCartModel =
              await viewCartRepository.getItemFromCart(token);
          if (itemsInCartModel.status != null &&
              itemsInCartModel.status == true) {
            double gstNumber =
                (itemsInCartModel.data?.cartData!.gstamount ?? 0).toDouble();
            double tax =
                (itemsInCartModel.data?.cartData!.taxable ?? 0).toDouble();
            double total =
                (itemsInCartModel.data?.cartData!.total ?? 0).toDouble();
            double totalToPay = gstNumber + tax + total;
            emit(ViewCartItemFetchSuccess(
                cartList: itemsInCartModel.data!.cartList,
                gstamount: gstNumber.toString(),
                taxable: tax.toString(),
                total: total.toString(),
                totalToPay: totalToPay));
          } else {
            emit(ViewCartFailure(error: Constants.emptyCart));
          }
        } on SocketException catch (error) {
          emit(ViewCartFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(ViewCartFailure(error: error.message.toString()));
        } catch (error) {
          emit(ViewCartFailure(error: 'Something went wrong'));
        }
      },
    );
    on<OrderNow>(
      (event, emit) async {
        try {
          if (event.customersId.isNotEmpty) {
            emit(ViewCartApiLoading());
            String? token = await SharedPreferenceHelper.getToken();
            AddToCartSuccessModel addToCartSuccessModel =
                await viewCartRepository.orderNow(token, event.customersId);
            if (addToCartSuccessModel.status!) {
              emit(OnOrderNowCompleted());
            } else {
              emit(ViewCartFailure(error: 'Cart removed is failed'));
            }
          } else {
            emit(ViewCartFailure(
                error: 'Please select the customer before placing the order!'));
          }
        } on SocketException catch (error) {
          emit(ViewCartFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(ViewCartFailure(error: error.message.toString()));
        } catch (error) {
          emit(ViewCartFailure(error: 'Something went wrong'));
        }
      },
    );
    on<ViewCartRemoveCartItem>(
      (event, emit) async {
        try {
          emit(ViewCartApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          AddToCartSuccessModel addToCartSuccessModel = await viewCartRepository
              .removeCartItem(token, event.products_id, "0", event.id);
          if (addToCartSuccessModel.status!) {
            emit(ViewCartItemUpdated());
          } else {
            emit(ViewCartFailure(error: 'Cart removed is failed'));
          }
        } on SocketException catch (error) {
          emit(ViewCartFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(ViewCartFailure(error: error.message.toString()));
        } catch (error) {
          emit(ViewCartFailure(error: 'Something went wrong'));
        }
      },
    );
    on<UpdateItemQuantityFromCart>(
      (event, emit) async {
        try {
          emit(ViewCartApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          AddToCartSuccessModel addToCartSuccessModel =
              await viewCartRepository.removeCartItem(
                  token, event.products_id, event.quantity, event.id);
          if (addToCartSuccessModel.status!) {
            emit(ViewCartItemUpdated());
          } else {
            emit(ViewCartFailure(error: 'Cart update is failed'));
          }
        } on SocketException catch (error) {
          emit(ViewCartFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(ViewCartFailure(error: error.message.toString()));
        } catch (error) {
          emit(ViewCartFailure(error: 'Something went wrong'));
        }
      },
    );
    on<CustomerFetchingEvent>(
      (event, emit) async {
        try {
          emit(ViewCartApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          Customers customers = await viewCartRepository.getCustomerList(token);
          if (customers.data.isEmpty) {
            emit(ViewCartFailure(error: "No Customers avaliable for now"));
          } else {
            emit(CustomerListFetched(customers: customers.data));
            List<String> customerNameList = [];
            customers.data.forEach((element) {
              customerNameList.add(element.name.toString());
            });
            emit(CustomerNameListFetched(customerNames: customerNameList));
          }
        } on SocketException catch (error) {
          print(error);
          emit(ViewCartFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(ViewCartFailure(error: error.message.toString()));
        } catch (error) {
          emit(ViewCartFailure(error: 'Something went wrong'));
        }
      },
    );
  }
}

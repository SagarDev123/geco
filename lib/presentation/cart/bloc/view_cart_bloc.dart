import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/model/itemsincartmodel.dart';
import 'package:geco/repository/viewcart_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/addtocartsuccessmodel.dart';
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
            int gstNumber = itemsInCartModel.data?.cartData!.gstamount ?? 0;
            int tax = itemsInCartModel.data?.cartData!.taxable ?? 0;
            double total = itemsInCartModel.data?.cartData!.total ?? 0;
            double totalToPay = gstNumber + tax + total;
            emit(ViewCartItemFetchSuccess(
                cartList: itemsInCartModel.data!.cartList,
                gstamount: gstNumber.toString(),
                taxable: tax.toString(),
                total: total.toString(),
                totalToPay: totalToPay));
          } else {
            emit(ViewCartFailure(error: 'Cart is empty'));
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
  }
}

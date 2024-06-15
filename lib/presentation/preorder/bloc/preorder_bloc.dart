import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/remote/exceptions.dart';
import 'package:geco/repository/preorder_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/addtocartsuccessmodel.dart';
import '../../../data/model/brand.dart';
import '../../../data/model/customer.dart';
import '../../../data/model/preorderlistmodel.dart';
import '../../../repository/dashboard_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/sharedpreferencehelper.dart';

part 'preorder_event.dart';
part 'preorder_state.dart';

class PreorderBloc extends Bloc<PreorderEvent, PreorderState> {
  PreOrderRepository preOrderRepository;
  DashboardRepository dashboardRepository;

  PreorderBloc(
      {required this.preOrderRepository, required this.dashboardRepository})
      : super(PreorderInitial()) {
    on<PreorderEvent>((event, emit) {});
    on<CustomerFetchingEvent>(
      (event, emit) async {
        try {
          emit(PreOrderApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          Customers customers = await preOrderRepository.getCustomerList(token);
          if (customers.data.isEmpty) {
            emit(PreviousOrderFailure(error: "No Customers avaliable for now"));
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
          emit(PreviousOrderFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(PreviousOrderFailure(error: error.message.toString()));
        } catch (error) {
          emit(PreviousOrderFailure(error: 'Something went wrong'));
        }
      },
    );
    on<PreviousOrder>(
      (event, emit) async {
        try {
          if (event.customerId.isEmpty) {
            emit(PreviousOrderFailure(error: 'Please select a customer!'));
          } else {
            emit(PreOrderApiLoading());
            String? token = await SharedPreferenceHelper.getToken();
            PreOrderListModel preOrderListModel = await preOrderRepository
                .getPreviiousOrder(token, event.customerId, event.brandId);
            if (preOrderListModel.status == false) {
              emit(PreviousOrderFailure(
                  error: "No Product in previous order list"));
            } else {
              if (preOrderListModel.data!.productList.isEmpty) {
                emit(PreviousOrderFailure(
                    error: "No Product in previous order list"));
              } else {
                emit(PreOrderListFetched(
                    preOrderList: preOrderListModel.data!.productList,
                    salesData: preOrderListModel.data!.salesData!));
              }
            }
          }
        } on SocketException catch (error) {
          print(error);
          emit(PreviousOrderFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(PreviousOrderFailure(error: error.message.toString()));
        } catch (error) {
          emit(PreviousOrderFailure(error: 'Something went wrong'));
        }
      },
    );
    on<BrandList>(
      (event, emit) async {
        try {
          emit(PreOrderApiLoading());
          String? token = await SharedPreferenceHelper.getToken();

          Brand brand = await dashboardRepository.getBrands(token);
          if (brand.data.isEmpty) {
            emit(PreviousOrderFailure(error: "No brands avaliable for now"));
          } else {
            emit(BrandListFetchCompleted(datum: brand.data));
            List<String> brandNames = [];
            brand.data.forEach((element) {
              brandNames.add(element.name.toString());
            });
            emit(BrandNameListFetchCompleted(brandNameList: brandNames));
          }
        } on SocketException catch (error) {
          print(error);
          emit(PreviousOrderFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(PreviousOrderFailure(error: error.message.toString()));
        } catch (error) {
          emit(PreviousOrderFailure(error: 'Something went wrong'));
        }
      },
    );

    on<ReOrder>(
      (event, emit) async {
        try {
          emit(PreOrderApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          AddToCartSuccessModel addToCartSuccessModel =
              await preOrderRepository.reOrderSales(token, event.salesId);
          if (addToCartSuccessModel.status!) {
            emit(ReOrderIsSuccess());
          } else {
            emit(PreviousOrderFailure(error: "No brands avaliable for now"));
          }
        } on SocketException catch (error) {
          print(error);
          emit(PreviousOrderFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(PreviousOrderFailure(error: error.message.toString()));
        } catch (error) {
          emit(PreviousOrderFailure(error: 'Something went wrong'));
        }
      },
    );
  }
}

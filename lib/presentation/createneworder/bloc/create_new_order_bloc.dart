import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/model/brand.dart';
import 'package:geco/repository/create_new_order_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/customer.dart';
import '../../../data/remote/exceptions.dart';
import '../../../utils/constants.dart';
import '../../../utils/sharedpreferencehelper.dart';

part 'create_new_order_event.dart';
part 'create_new_order_state.dart';

class CreateNewOrderBloc
    extends Bloc<CreateNewOrderEvent, CreateNewOrderState> {
  CreateNewOrderRepository createNewOrderRepository;
  CreateNewOrderBloc({required this.createNewOrderRepository})
      : super(CreateNewOrderInitial()) {
    on<CreateNewOrderEvent>((event, emit) {});
    on<CustomerFetchingEvent>(
      (event, emit) async {
        try {
          emit(CreateNewOrderApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          Customers customers =
              await createNewOrderRepository.getCustomerList(token);
          if (customers.data.isEmpty) {
            emit(
                CreateNewOrderFailure(error: "No Customers avaliable for now"));
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
          emit(CreateNewOrderFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(CreateNewOrderFailure(error: error.message.toString()));
        } catch (error) {
          emit(CreateNewOrderFailure(error: 'Something went wrong'));
        }
      },
    );
    on<ShowAllBrandForTheUser>(
      (event, emit) async {
        try {
          emit(CreateNewOrderApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          Brand brand = await createNewOrderRepository.getBrands(token);
          if (brand.data.isEmpty) {
            emit(
                CreateNewOrderFailure(error: "No Customers avaliable for now"));
          } else {
            emit(BrandFetchingCompleted(brand: brand.data));
          }
        } on SocketException catch (error) {
          print(error);
          emit(CreateNewOrderFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(CreateNewOrderFailure(error: error.message.toString()));
        } catch (error) {
          emit(CreateNewOrderFailure(error: 'Something went wrong'));
        }
      },
    );
  }
}

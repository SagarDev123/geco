import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/model/customer.dart';
import 'package:geco/repository/customer_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/addcustomermodel.dart';
import '../../../data/model/addtocartsuccessmodel.dart';
import '../../../data/remote/exceptions.dart';
import '../../../utils/constants.dart';
import '../../../utils/sharedpreferencehelper.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerRepository customerRepository;
  CustomerBloc({required this.customerRepository}) : super(CustomerInitial()) {
    on<CustomerEvent>((event, emit) {});
    on<AddNewCustomer>(
      (event, emit) async {
        try {
          emit(CustomersApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          AddCustomerModel customers = await customerRepository.addCustomer(
              token,
              event.name,
              event.storeName,
              event.mobileNumber,
              event.gstNumber,
              event.address);

          if (!customers.status!) {
            emit(CustomerFailure(error: "Add customer action failed!"));
          } else {
            emit(AddCustomerSuccess());
          }
        } on SocketException catch (error) {
          print(error);
          emit(CustomerFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(CustomerFailure(error: error.message.toString()));
        } catch (error) {
          emit(CustomerFailure(error: 'Something went wrong'));
        }
      },
    );
    on<CustomerListFetching>(
      (event, emit) async {
        try {
          emit(CustomersApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          Customers customers =
              await customerRepository.getCustomerList(token, event.name);
          print(event.name);
          if (customers.data.isEmpty) {
            emit(CustomerFailure(error: "No Customers avaliable for now"));
          } else {
            emit(CustomerListFetched(customers: customers.data));
          }
        } on SocketException catch (error) {
          print(error);
          emit(CustomerFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(CustomerFailure(error: error.message.toString()));
        } catch (error) {
          emit(CustomerFailure(error: 'Something went wrong'));
        }
      },
    );
  }
}

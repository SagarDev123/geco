import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/model/brand.dart';
import 'package:geco/data/model/user.dart';
import 'package:geco/repository/dashboard_repository.dart';
import 'package:geco/utils/sharedpreferencehelper.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/exceptions.dart';
import '../../../utils/constants.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardRepository dashboardRepository;
  DashboardBloc({required this.dashboardRepository})
      : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});
    on<DashBoardBrandListFetch>(
      (event, emit) async {
        try {
          emit(DashboardApiLoading());
          String? token = await SharedPreferenceHelper.getToken();
          print(token);
          Brand brand = await dashboardRepository.getBrands(token);
          if (brand.data.isEmpty) {
            emit(DashboardFailure(error: "No brands avaliable for now"));
          } else {
            emit(DashBoardFetchingCompleted(datum: brand.data));
          }
        } on SocketException catch (error) {
          print(error);
          emit(DashboardFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(DashboardFailure(error: error.message.toString()));
        } catch (error) {
          emit(DashboardFailure(error: 'Something went wrong'));
        }
      },
    );
  }
}

part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

class DashboardApiLoading extends DashboardState {}

class DashboardFailure extends DashboardState {
  final String error;
  DashboardFailure({required this.error});
}

class DashBoardFetchingCompleted extends DashboardState {
  final List<BrandData> datum;
  DashBoardFetchingCompleted({required this.datum});
}

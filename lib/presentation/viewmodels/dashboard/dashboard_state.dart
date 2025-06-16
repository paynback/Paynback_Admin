part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Map<String, String> stats;

  DashboardLoaded(this.stats);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? error;

  const LoginState({required this.status, this.error});
  const LoginState.initial() : this(status: LoginStatus.initial);

  LoginState copyWith({LoginStatus? status, String? error}) =>
      LoginState(status: status ?? this.status, error: error ?? this.error);

  @override
  List<Object?> get props => [status, error];
}
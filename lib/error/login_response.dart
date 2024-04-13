class LoginResponse {
  final bool isSuccess;
  final String? message;

  LoginResponse({
    required this.isSuccess,
    this.message,
  });
}

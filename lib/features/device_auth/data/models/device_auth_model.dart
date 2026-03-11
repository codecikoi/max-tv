class DeviceAuthRequest {
  final String userCode;

  const DeviceAuthRequest({required this.userCode});

  Map<String, dynamic> toJson() => {'user_code': userCode};
}

class DeviceAuthApproval {
  final String state;
  final String clientId;
  final String authToken;

  const DeviceAuthApproval({
    required this.state,
    required this.clientId,
    required this.authToken,
  });

  Map<String, dynamic> toJson() => {
        'state': state,
        'client_id': clientId,
        'auth_token': authToken,
      };
}

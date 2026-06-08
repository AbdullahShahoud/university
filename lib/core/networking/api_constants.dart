class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://209.97.134.208/api/v1',
  );

  static const String serverTime = '/auth/server-time';

  static const String registerDevice = '/device/register';
  static const String verifyDeviceToken = '/device/verify-token';
  static const String myDevices = '/device/my-devices';
  static const String updateDevice = '/device/'; // Append deviceId
  static const String revokeDevice = '/device/{deviceId}';

  static const String loginUser = '/auth/login';
  static const String registerUser = '/auth/signup';
  static const String refreshToken = '/auth/refreshToken';
  static const String logoutUser = '/auth/logout';

  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String verifyDevice = '/auth/verify-device';
  static const String resendVerification = '/auth/resend-verification';

  static const String me = '/auth/me';
  static const String pinSetup = '/auth/pin/setup';
  static const String pinValidate = '/auth/pin/validate';
  static const String pinReset = '/auth/pin/reset';
  static const String pinRequestReset = '/auth/pin/request-reset';
  static const String pinStatus = '/auth/pin/status';
  static const String pinValidateForOperation = '/auth/pin/validate/operation';
  static const String biometricRegistrationChallenge =
      '/auth/biometric/challenge';
  static const String biometricRegister = '/auth/biometric/register';
  static const String biometricStatus = '/auth/biometric/status';
  static const String biometricDisable = '/auth/biometric/disable';
  static const String biometricDevices = '/auth/biometric/devices';
  static const String biometricChallenge = '/auth/biometric/challenge';
  static const String biometricVerify = '/auth/biometric/verify';

  static const String walletsMe = '/wallets/me';
  static const String currencies = '/wallets/currencies';
  static const String ensureWallet = '/wallets/ensure';
  static const String walletDetails = '/wallets/details';
  static const String walletBalance = '/wallets/balance';
  static const String walletLimits = '/wallets/limits';
  static const String walletStatement = '/wallets/statement';
  static const String walletStatementExport = '/wallets/statement/export';
  static const String walletExportStatus = '/wallets/export/status';

  static const String kycDocumentsUpload = '/kyc/documents/upload';
  static const String kycDocuments = '/kyc/documents';
  static const String kycDocumentDownloadToken = '/kyc/documents';
  static const String kycSubmissions = '/kyc/submissions';
  static const String kycSubmissionCancel = '/kyc/submissions';

  static const String initiateTransfer = '/transfer/initiate';
  static const String transferChallenge = '/transfer/challenge';
  static const String authorizeTransfer = '/transfer/authorize';
  static const String executeTransfer = '/transfer/execute';

  static const String getTransactionDetail = '/transactions/detail';
  static const String getTransactionWithCounterparty =
      '/transactions/counterparty';
  static const String getTransactionsWithCounterpartyByUsername =
      '/transactions/counterparty/username';

  static const String nearbyAgents = '/agents/nearby';

  static const String cashInInitiate = '/cash-in/initiate';
  static const String cashInExecute = '/cash-in/execute';
  static const String cashInCancel = '/cash-in/cancel';
  static const String cashOutInitiate = '/cash-out/initiate';
  static const String cashOutExecute = '/cash-out/execute';
  static const String cashOutCancel = '/cash-out/cancel';

  static const String generateStaticQr = '/qr/generate/static';
  static const String generateDynamicQr = '/qr/generate/dynamic';
  static const String getQrDetails = '/qr/details';
  static const String listMerchantQrCodes = '/qr/merchant/list';
  static const String revokeQr = '/qr/revoke';
  static const String getQrTransactions = '/qr/transactions';
  static const String scanQr = '/qr/scan';
  static const String initiateQrPayment = '/qr/payment/initiate';
  static const String authorizeQrPayment = '/qr/payment/authorize';
  static const String executeQrPayment = '/qr/payment/execute';
  static const String qrPaymentHistory = '/qr/payment/history';

  static const String notifications = '/audience/notifications';
  static const String notificationsUnreadCount =
      '/audience/notifications/unread-count';
  static const String notificationReadAll = '/audience/notifications/read-all';

  static const String deviceFcmToken = '/device/fcm-token';
  static const String pinChange = '/auth/pin/change';
  static const String updateDeviceName = '/device/name';

  static const String changePassword = '/auth/change-password';
  static const String updateUsername = '/auth/update-username';
  static const String deleteAccount = '/auth/delete-account';

  static const String exchangeQuote = '/exchange/quote';
  static const String exchangeExecute = '/exchange/execute';
  static const String exchangeQuoteCancel = '/exchange/quote/cancel';
  static const String exchangeSnapshot = '/exchange/snapshot';

  static const String conversations = '/conversations';
  static const String conversationsUnreadCount = '/conversations/unread-count';
  static const String conversationWith = '/conversations/with';
  static const String conversationMessages = '/conversations/messages';
  static const String conversationRead = '/conversations/read';

  static const String paymentRequests = '/payment-requests';
  static const String paymentRequestAccept = '/payment-requests/accept';
  static const String paymentRequestDecline = '/payment-requests/decline';
  static const String paymentRequestCancel = '/payment-requests/cancel';
}

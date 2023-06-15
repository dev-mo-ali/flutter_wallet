import 'package:http/http.dart' as http;
import 'package:sun_point/server/response.dart';
import 'package:sun_point/server/server.dart';

class WalletAPI {
  static Future<ServerResponse> getMyWallet() async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_my_wallets');

    return response;
  }

  static Future<ServerResponse> checkTransfer(
      int walletConfigID, int receiverID, double amount) async {
    ServerResponse response =
        await Server.send(http.post, 'user/transfer_check', body: {
      'transactions': [
        {'user_id': receiverID, 'amount': amount}
      ],
      'wallet_config_id': walletConfigID
    });
    return response;
  }

  static Future<ServerResponse> transfer(
      int walletConfigID, int receiverID, double amount, String tpin) async {
    ServerResponse response =
        await Server.send(http.post, 'user/request_transfer', body: {
      'transactions': [
        {'user_id': receiverID, 'amount': amount}
      ],
      'wallet_config_id': walletConfigID,
      "tpin": tpin
    });
    return response;
  }

  static Future<ServerResponse> sendReceiveRequest(
      int walletConfigID, int userID, double amount) async {
    ServerResponse response =
        await Server.send(http.post, 'user/request_fund', body: {
      'wallet_config_id': walletConfigID,
      'amount': amount,
      'sender': {
        "get_user": {"id": userID}
      }
    });
    return response;
  }

  static Future<ServerResponse> getTopUpConfig() async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_topup_config');

    return response;
  }

  static Future<ServerResponse> getEstimatedTopupPoints(double amount) async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_topup_estimated_points', body: {
      'amount': amount,
    });
    return response;
  }

  static Future<ServerResponse> topUpCheckVoucher(String voucherCode) async {
    ServerResponse response = await Server.send(
        http.post, 'user/topup_check_voucher',
        body: {'is_voucher': true, "voucher_code": voucherCode});
    return response;
  }

  static Future<ServerResponse> topUp(
    double? amount,
    bool isVoucher,
    String voucherCode,
  ) async {
    ServerResponse response = await Server.send(
        http.post, 'user/create_topup_request', body: {
      'amount': amount,
      'is_voucher': isVoucher,
      "voucher_code": voucherCode
    });
    return response;
  }

  static Future<ServerResponse> getWithdrawConfig() async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_withdrawal_config');

    return response;
  }

  static Future<List> getEstimatedWithdrawalUSDT(double amount) async {
    ServerResponse response = await Server.send(
        http.post, 'user/get_estimated_withdrawal_usdt',
        body: {
          'amount': amount,
        });
    return [response, amount];
  }

  static Future<ServerResponse> withdrawCheck(num amount) async {
    ServerResponse response =
        await Server.send(http.post, 'user/withdrawal_check', body: {
      'wallet_config_id': 1,
      'amount': amount,
    });
    return response;
  }

  static Future<ServerResponse> withdraw(
      num amount, int bankID, String accountNumber, String holderName) async {
    ServerResponse response =
        await Server.send(http.post, 'user/create_withdrawal_request', body: {
      'amount': amount,
      "bank_id": bankID,
      'bank_account_number': accountNumber,
      'bank_holder_name': holderName
    });
    return response;
  }

  static Future<ServerResponse> getTransactions(
      int userWalletID, int page) async {
    ServerResponse response = await Server.sendDio('user/get_transactions',
        body: {'user_wallet_id': userWalletID, 'page': page});
    return response;
  }

  static Future<ServerResponse> getTransaction(int id) async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_transaction', body: {
      'id': id,
    });
    return response;
  }

  static Future<ServerResponse> cancelTopupRequest(int id) async {
    ServerResponse response =
        await Server.send(http.post, 'user/cancel_topup_request', body: {
      'id': id,
    });
    return response;
  }

  static Future<ServerResponse> cancelWithdrawalRequest(int id) async {
    ServerResponse response =
        await Server.send(http.post, 'user/cancel_withdrawal_request', body: {
      'id': id,
    });
    return response;
  }

  static Future<ServerResponse> getReloadWallet() async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_reload_wallet');
    return response;
  }

  static Future<ServerResponse> getBanks() async {
    ServerResponse response = await Server.send(http.post, 'user/get_banks');
    return response;
  }

  static Future<ServerResponse> getWithdrawRequests(int page) async {
    ServerResponse response = await Server.send(
        http.post, 'user/get_withdrawal_requests',
        body: {'page': page});
    return response;
  }

  static Future<ServerResponse> getTopupRequests(int page) async {
    ServerResponse response = await Server.send(
        http.post, 'user/get_topup_requests',
        body: {'page': page});
    return response;
  }

  static Future<ServerResponse> getWithdrawRequest(int id) async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_withdrawal_request', body: {
      'id': id,
    });
    return response;
  }

  static Future<ServerResponse> getTopupRequest(int id) async {
    ServerResponse response =
        await Server.send(http.post, 'user/get_topup_request', body: {
      'id': id,
    });
    return response;
  }
}

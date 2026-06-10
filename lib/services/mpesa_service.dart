import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MpesaService {
  static const String _consumerKey = 'YOUR_CONSUMER_KEY';
  static const String _consumerSecret = 'YOUR_CONSUMER_SECRET';
  static const String _shortCode = '174379';
  static const String _passKey =
      'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
  static const String _callbackUrl =
      'https://yourdomain.com/mpesa/callback';
  static const String _baseUrl = 'https://sandbox.safaricom.co.ke';

  static Future<String?> _getAccessToken() async {
    try {
      final credentials =
          base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/oauth/v1/generate?grant_type=client_credentials'),
        headers: {'Authorization': 'Basic $credentials'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      }
      return null;
    } catch (e) {
      debugPrint('M-Pesa token error: $e');
      return null;
    }
  }

  static Future<MpesaResult> stkPush({
    required String phoneNumber,
    required double amount,
    required String accountRef,
  }) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return MpesaResult.error(
            'Could not connect to M-Pesa. Check your internet connection.');
      }

      final phone = _formatPhone(phoneNumber);
      if (phone == null) {
        return MpesaResult.error(
            'Invalid phone number. Use format: 07XX XXX XXX');
      }

      final timestamp = _getTimestamp();
      final password = base64Encode(
          utf8.encode('$_shortCode$_passKey$timestamp'));

      final body = {
        'BusinessShortCode': _shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount.toInt().toString(),
        'PartyA': phone,
        'PartyB': _shortCode,
        'PhoneNumber': phone,
        'CallBackURL': _callbackUrl,
        'AccountReference': accountRef,
        'TransactionDesc': 'MarketFresh Order Payment',
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/mpesa/stkpush/v1/processrequest'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ResponseCode'] == '0') {
          return MpesaResult.success(
            checkoutRequestId: data['CheckoutRequestID'],
            message:
                'M-Pesa prompt sent to $phoneNumber. Enter your PIN to complete payment.',
          );
        } else {
          return MpesaResult.error(
              data['ResponseDescription'] ?? 'M-Pesa request failed.');
        }
      } else {
        return MpesaResult.error(
            'M-Pesa server error (${response.statusCode}). Try again.');
      }
    } catch (e) {
      debugPrint('STK Push error: $e');
      return MpesaResult.error(
          'Network error. Check your connection and try again.');
    }
  }

  static Future<MpesaQueryResult> queryTransaction(
      String checkoutRequestId) async {
    try {
      final token = await _getAccessToken();
      if (token == null) return MpesaQueryResult.unknown;

      final timestamp = _getTimestamp();
      final password = base64Encode(
          utf8.encode('$_shortCode$_passKey$timestamp'));

      final response = await http.post(
        Uri.parse('$_baseUrl/mpesa/stkpushquery/v1/query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'BusinessShortCode': _shortCode,
          'Password': password,
          'Timestamp': timestamp,
          'CheckoutRequestID': checkoutRequestId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resultCode = data['ResultCode'];
        if (resultCode == '0') return MpesaQueryResult.success;
        if (resultCode == '1032') return MpesaQueryResult.cancelled;
        return MpesaQueryResult.failed;
      }
      return MpesaQueryResult.unknown;
    } catch (e) {
      return MpesaQueryResult.unknown;
    }
  }

  static String? _formatPhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('254') && digits.length == 12) return digits;
    if (digits.startsWith('0') && digits.length == 10) {
      return '254${digits.substring(1)}';
    }
    if (digits.startsWith('7') && digits.length == 9) {
      return '254$digits';
    }
    return null;
  }

  static String _getTimestamp() {
    final now = DateTime.now();
    return '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
  }
}

class MpesaResult {
  final bool isSuccess;
  final String message;
  final String? checkoutRequestId;

  const MpesaResult._({
    required this.isSuccess,
    required this.message,
    this.checkoutRequestId,
  });

  factory MpesaResult.success({
    required String checkoutRequestId,
    required String message,
  }) =>
      MpesaResult._(
        isSuccess: true,
        message: message,
        checkoutRequestId: checkoutRequestId,
      );

  factory MpesaResult.error(String message) =>
      MpesaResult._(isSuccess: false, message: message);
}

enum MpesaQueryResult { success, cancelled, failed, unknown }
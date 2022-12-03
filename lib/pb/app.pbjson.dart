///
//  Generated code. Do not modify.
//  source: app.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use wSTypeDescriptor instead')
const WSType$json = const {
  '1': 'WSType',
  '2': const [
    const {'1': 'TYPE_FUTURE_TICK', '2': 0},
    const {'1': 'TYPE_FUTURE_ORDER', '2': 1},
    const {'1': 'TYPE_PERIOD_TRADE_VOLUME', '2': 2},
    const {'1': 'TYPE_TRADE_INDEX', '2': 3},
    const {'1': 'TYPE_FUTURE_POSITION', '2': 4},
    const {'1': 'TYPE_ASSIST_STATUS', '2': 5},
    const {'1': 'TYPE_ERR_MESSAGE', '2': 6},
  ],
};

/// Descriptor for `WSType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wSTypeDescriptor = $convert.base64Decode('CgZXU1R5cGUSFAoQVFlQRV9GVVRVUkVfVElDSxAAEhUKEVRZUEVfRlVUVVJFX09SREVSEAESHAoYVFlQRV9QRVJJT0RfVFJBREVfVk9MVU1FEAISFAoQVFlQRV9UUkFERV9JTkRFWBADEhgKFFRZUEVfRlVUVVJFX1BPU0lUSU9OEAQSFgoSVFlQRV9BU1NJU1RfU1RBVFVTEAUSFAoQVFlQRV9FUlJfTUVTU0FHRRAG');
@$core.Deprecated('Use wSMessageDescriptor instead')
const WSMessage$json = const {
  '1': 'WSMessage',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.sinopac_forwarder.WSType', '10': 'type'},
    const {'1': 'future_tick', '3': 2, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSFutureTick', '9': 0, '10': 'futureTick'},
    const {'1': 'future_order', '3': 3, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSFutureOrder', '9': 0, '10': 'futureOrder'},
    const {'1': 'period_trade_volume', '3': 4, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSPeriodTradeVolume', '9': 0, '10': 'periodTradeVolume'},
    const {'1': 'trade_index', '3': 5, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSTradeIndex', '9': 0, '10': 'tradeIndex'},
    const {'1': 'future_position', '3': 6, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSFuturePosition', '9': 0, '10': 'futurePosition'},
    const {'1': 'assit_status', '3': 7, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSAssitStatus', '9': 0, '10': 'assitStatus'},
    const {'1': 'err_message', '3': 8, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSErrMessage', '9': 0, '10': 'errMessage'},
  ],
  '8': const [
    const {'1': 'data'},
  ],
};

/// Descriptor for `WSMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSMessageDescriptor = $convert.base64Decode('CglXU01lc3NhZ2USLQoEdHlwZRgBIAEoDjIZLnNpbm9wYWNfZm9yd2FyZGVyLldTVHlwZVIEdHlwZRJCCgtmdXR1cmVfdGljaxgCIAEoCzIfLnNpbm9wYWNfZm9yd2FyZGVyLldTRnV0dXJlVGlja0gAUgpmdXR1cmVUaWNrEkUKDGZ1dHVyZV9vcmRlchgDIAEoCzIgLnNpbm9wYWNfZm9yd2FyZGVyLldTRnV0dXJlT3JkZXJIAFILZnV0dXJlT3JkZXISWAoTcGVyaW9kX3RyYWRlX3ZvbHVtZRgEIAEoCzImLnNpbm9wYWNfZm9yd2FyZGVyLldTUGVyaW9kVHJhZGVWb2x1bWVIAFIRcGVyaW9kVHJhZGVWb2x1bWUSQgoLdHJhZGVfaW5kZXgYBSABKAsyHy5zaW5vcGFjX2ZvcndhcmRlci5XU1RyYWRlSW5kZXhIAFIKdHJhZGVJbmRleBJOCg9mdXR1cmVfcG9zaXRpb24YBiABKAsyIy5zaW5vcGFjX2ZvcndhcmRlci5XU0Z1dHVyZVBvc2l0aW9uSABSDmZ1dHVyZVBvc2l0aW9uEkUKDGFzc2l0X3N0YXR1cxgHIAEoCzIgLnNpbm9wYWNfZm9yd2FyZGVyLldTQXNzaXRTdGF0dXNIAFILYXNzaXRTdGF0dXMSQgoLZXJyX21lc3NhZ2UYCCABKAsyHy5zaW5vcGFjX2ZvcndhcmRlci5XU0Vyck1lc3NhZ2VIAFIKZXJyTWVzc2FnZUIGCgRkYXRh');
@$core.Deprecated('Use wSErrMessageDescriptor instead')
const WSErrMessage$json = const {
  '1': 'WSErrMessage',
  '2': const [
    const {'1': 'err_code', '3': 1, '4': 1, '5': 3, '10': 'errCode'},
    const {'1': 'response', '3': 2, '4': 1, '5': 9, '10': 'response'},
  ],
};

/// Descriptor for `WSErrMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSErrMessageDescriptor = $convert.base64Decode('CgxXU0Vyck1lc3NhZ2USGQoIZXJyX2NvZGUYASABKANSB2VyckNvZGUSGgoIcmVzcG9uc2UYAiABKAlSCHJlc3BvbnNl');
@$core.Deprecated('Use wSFutureOrderDescriptor instead')
const WSFutureOrder$json = const {
  '1': 'WSFutureOrder',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'base_order', '3': 2, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSOrder', '10': 'baseOrder'},
  ],
};

/// Descriptor for `WSFutureOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSFutureOrderDescriptor = $convert.base64Decode('Cg1XU0Z1dHVyZU9yZGVyEhIKBGNvZGUYASABKAlSBGNvZGUSOQoKYmFzZV9vcmRlchgCIAEoCzIaLnNpbm9wYWNfZm9yd2FyZGVyLldTT3JkZXJSCWJhc2VPcmRlcg==');
@$core.Deprecated('Use wSOrderDescriptor instead')
const WSOrder$json = const {
  '1': 'WSOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    const {'1': 'status', '3': 2, '4': 1, '5': 3, '10': 'status'},
    const {'1': 'order_time', '3': 3, '4': 1, '5': 9, '10': 'orderTime'},
    const {'1': 'action', '3': 4, '4': 1, '5': 3, '10': 'action'},
    const {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    const {'1': 'quantity', '3': 6, '4': 1, '5': 3, '10': 'quantity'},
    const {'1': 'trade_time', '3': 7, '4': 1, '5': 9, '10': 'tradeTime'},
    const {'1': 'tick_time', '3': 8, '4': 1, '5': 9, '10': 'tickTime'},
    const {'1': 'group_id', '3': 9, '4': 1, '5': 9, '10': 'groupId'},
  ],
};

/// Descriptor for `WSOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSOrderDescriptor = $convert.base64Decode('CgdXU09yZGVyEhkKCG9yZGVyX2lkGAEgASgJUgdvcmRlcklkEhYKBnN0YXR1cxgCIAEoA1IGc3RhdHVzEh0KCm9yZGVyX3RpbWUYAyABKAlSCW9yZGVyVGltZRIWCgZhY3Rpb24YBCABKANSBmFjdGlvbhIUCgVwcmljZRgFIAEoAVIFcHJpY2USGgoIcXVhbnRpdHkYBiABKANSCHF1YW50aXR5Eh0KCnRyYWRlX3RpbWUYByABKAlSCXRyYWRlVGltZRIbCgl0aWNrX3RpbWUYCCABKAlSCHRpY2tUaW1lEhkKCGdyb3VwX2lkGAkgASgJUgdncm91cElk');
@$core.Deprecated('Use wSFutureTickDescriptor instead')
const WSFutureTick$json = const {
  '1': 'WSFutureTick',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'tick_time', '3': 2, '4': 1, '5': 9, '10': 'tickTime'},
    const {'1': 'open', '3': 3, '4': 1, '5': 1, '10': 'open'},
    const {'1': 'underlying_price', '3': 4, '4': 1, '5': 1, '10': 'underlyingPrice'},
    const {'1': 'bid_side_total_vol', '3': 5, '4': 1, '5': 3, '10': 'bidSideTotalVol'},
    const {'1': 'ask_side_total_vol', '3': 6, '4': 1, '5': 3, '10': 'askSideTotalVol'},
    const {'1': 'avg_price', '3': 7, '4': 1, '5': 1, '10': 'avgPrice'},
    const {'1': 'close', '3': 8, '4': 1, '5': 1, '10': 'close'},
    const {'1': 'high', '3': 9, '4': 1, '5': 1, '10': 'high'},
    const {'1': 'low', '3': 10, '4': 1, '5': 1, '10': 'low'},
    const {'1': 'amount', '3': 11, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'total_amount', '3': 12, '4': 1, '5': 1, '10': 'totalAmount'},
    const {'1': 'volume', '3': 13, '4': 1, '5': 3, '10': 'volume'},
    const {'1': 'total_volume', '3': 14, '4': 1, '5': 3, '10': 'totalVolume'},
    const {'1': 'tick_type', '3': 15, '4': 1, '5': 3, '10': 'tickType'},
    const {'1': 'chg_type', '3': 16, '4': 1, '5': 3, '10': 'chgType'},
    const {'1': 'price_chg', '3': 17, '4': 1, '5': 1, '10': 'priceChg'},
    const {'1': 'pct_chg', '3': 18, '4': 1, '5': 1, '10': 'pctChg'},
  ],
};

/// Descriptor for `WSFutureTick`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSFutureTickDescriptor = $convert.base64Decode('CgxXU0Z1dHVyZVRpY2sSEgoEY29kZRgBIAEoCVIEY29kZRIbCgl0aWNrX3RpbWUYAiABKAlSCHRpY2tUaW1lEhIKBG9wZW4YAyABKAFSBG9wZW4SKQoQdW5kZXJseWluZ19wcmljZRgEIAEoAVIPdW5kZXJseWluZ1ByaWNlEisKEmJpZF9zaWRlX3RvdGFsX3ZvbBgFIAEoA1IPYmlkU2lkZVRvdGFsVm9sEisKEmFza19zaWRlX3RvdGFsX3ZvbBgGIAEoA1IPYXNrU2lkZVRvdGFsVm9sEhsKCWF2Z19wcmljZRgHIAEoAVIIYXZnUHJpY2USFAoFY2xvc2UYCCABKAFSBWNsb3NlEhIKBGhpZ2gYCSABKAFSBGhpZ2gSEAoDbG93GAogASgBUgNsb3cSFgoGYW1vdW50GAsgASgBUgZhbW91bnQSIQoMdG90YWxfYW1vdW50GAwgASgBUgt0b3RhbEFtb3VudBIWCgZ2b2x1bWUYDSABKANSBnZvbHVtZRIhCgx0b3RhbF92b2x1bWUYDiABKANSC3RvdGFsVm9sdW1lEhsKCXRpY2tfdHlwZRgPIAEoA1IIdGlja1R5cGUSGQoIY2hnX3R5cGUYECABKANSB2NoZ1R5cGUSGwoJcHJpY2VfY2hnGBEgASgBUghwcmljZUNoZxIXCgdwY3RfY2hnGBIgASgBUgZwY3RDaGc=');
@$core.Deprecated('Use outInVolumeDescriptor instead')
const OutInVolume$json = const {
  '1': 'OutInVolume',
  '2': const [
    const {'1': 'out_volume', '3': 1, '4': 1, '5': 3, '10': 'outVolume'},
    const {'1': 'in_volume', '3': 2, '4': 1, '5': 3, '10': 'inVolume'},
  ],
};

/// Descriptor for `OutInVolume`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outInVolumeDescriptor = $convert.base64Decode('CgtPdXRJblZvbHVtZRIdCgpvdXRfdm9sdW1lGAEgASgDUglvdXRWb2x1bWUSGwoJaW5fdm9sdW1lGAIgASgDUghpblZvbHVtZQ==');
@$core.Deprecated('Use wSPeriodTradeVolumeDescriptor instead')
const WSPeriodTradeVolume$json = const {
  '1': 'WSPeriodTradeVolume',
  '2': const [
    const {'1': 'first_period', '3': 1, '4': 1, '5': 11, '6': '.sinopac_forwarder.OutInVolume', '10': 'firstPeriod'},
    const {'1': 'second_period', '3': 2, '4': 1, '5': 11, '6': '.sinopac_forwarder.OutInVolume', '10': 'secondPeriod'},
    const {'1': 'third_period', '3': 3, '4': 1, '5': 11, '6': '.sinopac_forwarder.OutInVolume', '10': 'thirdPeriod'},
    const {'1': 'fourth_period', '3': 4, '4': 1, '5': 11, '6': '.sinopac_forwarder.OutInVolume', '10': 'fourthPeriod'},
  ],
};

/// Descriptor for `WSPeriodTradeVolume`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSPeriodTradeVolumeDescriptor = $convert.base64Decode('ChNXU1BlcmlvZFRyYWRlVm9sdW1lEkEKDGZpcnN0X3BlcmlvZBgBIAEoCzIeLnNpbm9wYWNfZm9yd2FyZGVyLk91dEluVm9sdW1lUgtmaXJzdFBlcmlvZBJDCg1zZWNvbmRfcGVyaW9kGAIgASgLMh4uc2lub3BhY19mb3J3YXJkZXIuT3V0SW5Wb2x1bWVSDHNlY29uZFBlcmlvZBJBCgx0aGlyZF9wZXJpb2QYAyABKAsyHi5zaW5vcGFjX2ZvcndhcmRlci5PdXRJblZvbHVtZVILdGhpcmRQZXJpb2QSQwoNZm91cnRoX3BlcmlvZBgEIAEoCzIeLnNpbm9wYWNfZm9yd2FyZGVyLk91dEluVm9sdW1lUgxmb3VydGhQZXJpb2Q=');
@$core.Deprecated('Use wSTradeIndexDescriptor instead')
const WSTradeIndex$json = const {
  '1': 'WSTradeIndex',
  '2': const [
    const {'1': 'tse', '3': 1, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSStockSnapShot', '10': 'tse'},
    const {'1': 'otc', '3': 2, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSStockSnapShot', '10': 'otc'},
    const {'1': 'nasdaq', '3': 3, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSYahooPrice', '10': 'nasdaq'},
    const {'1': 'nf', '3': 4, '4': 1, '5': 11, '6': '.sinopac_forwarder.WSYahooPrice', '10': 'nf'},
  ],
};

/// Descriptor for `WSTradeIndex`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSTradeIndexDescriptor = $convert.base64Decode('CgxXU1RyYWRlSW5kZXgSNAoDdHNlGAEgASgLMiIuc2lub3BhY19mb3J3YXJkZXIuV1NTdG9ja1NuYXBTaG90UgN0c2USNAoDb3RjGAIgASgLMiIuc2lub3BhY19mb3J3YXJkZXIuV1NTdG9ja1NuYXBTaG90UgNvdGMSNwoGbmFzZGFxGAMgASgLMh8uc2lub3BhY19mb3J3YXJkZXIuV1NZYWhvb1ByaWNlUgZuYXNkYXESLwoCbmYYBCABKAsyHy5zaW5vcGFjX2ZvcndhcmRlci5XU1lhaG9vUHJpY2VSAm5m');
@$core.Deprecated('Use wSStockSnapShotDescriptor instead')
const WSStockSnapShot$json = const {
  '1': 'WSStockSnapShot',
  '2': const [
    const {'1': 'stock_num', '3': 1, '4': 1, '5': 9, '10': 'stockNum'},
    const {'1': 'stock_name', '3': 2, '4': 1, '5': 9, '10': 'stockName'},
    const {'1': 'snap_time', '3': 3, '4': 1, '5': 9, '10': 'snapTime'},
    const {'1': 'open', '3': 4, '4': 1, '5': 1, '10': 'open'},
    const {'1': 'high', '3': 5, '4': 1, '5': 1, '10': 'high'},
    const {'1': 'low', '3': 6, '4': 1, '5': 1, '10': 'low'},
    const {'1': 'close', '3': 7, '4': 1, '5': 1, '10': 'close'},
    const {'1': 'tick_type', '3': 8, '4': 1, '5': 9, '10': 'tickType'},
    const {'1': 'price_chg', '3': 9, '4': 1, '5': 1, '10': 'priceChg'},
    const {'1': 'pct_chg', '3': 10, '4': 1, '5': 1, '10': 'pctChg'},
    const {'1': 'chg_type', '3': 11, '4': 1, '5': 9, '10': 'chgType'},
    const {'1': 'volume', '3': 12, '4': 1, '5': 3, '10': 'volume'},
    const {'1': 'volume_sum', '3': 13, '4': 1, '5': 3, '10': 'volumeSum'},
    const {'1': 'amount', '3': 14, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'amount_sum', '3': 15, '4': 1, '5': 3, '10': 'amountSum'},
    const {'1': 'yesterday_volume', '3': 16, '4': 1, '5': 1, '10': 'yesterdayVolume'},
    const {'1': 'volume_ratio', '3': 17, '4': 1, '5': 1, '10': 'volumeRatio'},
  ],
};

/// Descriptor for `WSStockSnapShot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSStockSnapShotDescriptor = $convert.base64Decode('Cg9XU1N0b2NrU25hcFNob3QSGwoJc3RvY2tfbnVtGAEgASgJUghzdG9ja051bRIdCgpzdG9ja19uYW1lGAIgASgJUglzdG9ja05hbWUSGwoJc25hcF90aW1lGAMgASgJUghzbmFwVGltZRISCgRvcGVuGAQgASgBUgRvcGVuEhIKBGhpZ2gYBSABKAFSBGhpZ2gSEAoDbG93GAYgASgBUgNsb3cSFAoFY2xvc2UYByABKAFSBWNsb3NlEhsKCXRpY2tfdHlwZRgIIAEoCVIIdGlja1R5cGUSGwoJcHJpY2VfY2hnGAkgASgBUghwcmljZUNoZxIXCgdwY3RfY2hnGAogASgBUgZwY3RDaGcSGQoIY2hnX3R5cGUYCyABKAlSB2NoZ1R5cGUSFgoGdm9sdW1lGAwgASgDUgZ2b2x1bWUSHQoKdm9sdW1lX3N1bRgNIAEoA1IJdm9sdW1lU3VtEhYKBmFtb3VudBgOIAEoA1IGYW1vdW50Eh0KCmFtb3VudF9zdW0YDyABKANSCWFtb3VudFN1bRIpChB5ZXN0ZXJkYXlfdm9sdW1lGBAgASgBUg95ZXN0ZXJkYXlWb2x1bWUSIQoMdm9sdW1lX3JhdGlvGBEgASgBUgt2b2x1bWVSYXRpbw==');
@$core.Deprecated('Use wSYahooPriceDescriptor instead')
const WSYahooPrice$json = const {
  '1': 'WSYahooPrice',
  '2': const [
    const {'1': 'last', '3': 1, '4': 1, '5': 1, '10': 'last'},
    const {'1': 'price', '3': 2, '4': 1, '5': 1, '10': 'price'},
    const {'1': 'updated_at', '3': 3, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `WSYahooPrice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSYahooPriceDescriptor = $convert.base64Decode('CgxXU1lhaG9vUHJpY2USEgoEbGFzdBgBIAEoAVIEbGFzdBIUCgVwcmljZRgCIAEoAVIFcHJpY2USHQoKdXBkYXRlZF9hdBgDIAEoCVIJdXBkYXRlZEF0');
@$core.Deprecated('Use wSFuturePositionDescriptor instead')
const WSFuturePosition$json = const {
  '1': 'WSFuturePosition',
  '2': const [
    const {'1': 'position', '3': 1, '4': 3, '5': 11, '6': '.sinopac_forwarder.Position', '10': 'position'},
  ],
};

/// Descriptor for `WSFuturePosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSFuturePositionDescriptor = $convert.base64Decode('ChBXU0Z1dHVyZVBvc2l0aW9uEjcKCHBvc2l0aW9uGAEgAygLMhsuc2lub3BhY19mb3J3YXJkZXIuUG9zaXRpb25SCHBvc2l0aW9u');
@$core.Deprecated('Use positionDescriptor instead')
const Position$json = const {
  '1': 'Position',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'direction', '3': 2, '4': 1, '5': 9, '10': 'direction'},
    const {'1': 'quantity', '3': 3, '4': 1, '5': 3, '10': 'quantity'},
    const {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
    const {'1': 'last_price', '3': 5, '4': 1, '5': 1, '10': 'lastPrice'},
    const {'1': 'pnl', '3': 6, '4': 1, '5': 1, '10': 'pnl'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode('CghQb3NpdGlvbhISCgRjb2RlGAEgASgJUgRjb2RlEhwKCWRpcmVjdGlvbhgCIAEoCVIJZGlyZWN0aW9uEhoKCHF1YW50aXR5GAMgASgDUghxdWFudGl0eRIUCgVwcmljZRgEIAEoAVIFcHJpY2USHQoKbGFzdF9wcmljZRgFIAEoAVIJbGFzdFByaWNlEhAKA3BubBgGIAEoAVIDcG5s');
@$core.Deprecated('Use wSAssitStatusDescriptor instead')
const WSAssitStatus$json = const {
  '1': 'WSAssitStatus',
  '2': const [
    const {'1': 'running', '3': 1, '4': 1, '5': 8, '10': 'running'},
  ],
};

/// Descriptor for `WSAssitStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wSAssitStatusDescriptor = $convert.base64Decode('Cg1XU0Fzc2l0U3RhdHVzEhgKB3J1bm5pbmcYASABKAhSB3J1bm5pbmc=');

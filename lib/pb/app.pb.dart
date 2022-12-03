///
//  Generated code. Do not modify.
//  source: app.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'app.pbenum.dart';

export 'app.pbenum.dart';

enum WSMessage_Data {
  futureTick,
  futureOrder,
  periodTradeVolume,
  tradeIndex,
  futurePosition,
  assitStatus,
  errMessage,
  notSet
}

class WSMessage extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, WSMessage_Data> _WSMessage_DataByTag = {
    2 : WSMessage_Data.futureTick,
    3 : WSMessage_Data.futureOrder,
    4 : WSMessage_Data.periodTradeVolume,
    5 : WSMessage_Data.tradeIndex,
    6 : WSMessage_Data.futurePosition,
    7 : WSMessage_Data.assitStatus,
    8 : WSMessage_Data.errMessage,
    0 : WSMessage_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8])
    ..e<WSType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: WSType.TYPE_FUTURE_TICK, valueOf: WSType.valueOf, enumValues: WSType.values)
    ..aOM<WSFutureTick>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'futureTick', subBuilder: WSFutureTick.create)
    ..aOM<WSFutureOrder>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'futureOrder', subBuilder: WSFutureOrder.create)
    ..aOM<WSPeriodTradeVolume>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'periodTradeVolume', subBuilder: WSPeriodTradeVolume.create)
    ..aOM<WSTradeIndex>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeIndex', subBuilder: WSTradeIndex.create)
    ..aOM<WSFuturePosition>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'futurePosition', subBuilder: WSFuturePosition.create)
    ..aOM<WSAssitStatus>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assitStatus', subBuilder: WSAssitStatus.create)
    ..aOM<WSErrMessage>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errMessage', subBuilder: WSErrMessage.create)
    ..hasRequiredFields = false
  ;

  WSMessage._() : super();
  factory WSMessage({
    WSType? type,
    WSFutureTick? futureTick,
    WSFutureOrder? futureOrder,
    WSPeriodTradeVolume? periodTradeVolume,
    WSTradeIndex? tradeIndex,
    WSFuturePosition? futurePosition,
    WSAssitStatus? assitStatus,
    WSErrMessage? errMessage,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (futureTick != null) {
      _result.futureTick = futureTick;
    }
    if (futureOrder != null) {
      _result.futureOrder = futureOrder;
    }
    if (periodTradeVolume != null) {
      _result.periodTradeVolume = periodTradeVolume;
    }
    if (tradeIndex != null) {
      _result.tradeIndex = tradeIndex;
    }
    if (futurePosition != null) {
      _result.futurePosition = futurePosition;
    }
    if (assitStatus != null) {
      _result.assitStatus = assitStatus;
    }
    if (errMessage != null) {
      _result.errMessage = errMessage;
    }
    return _result;
  }
  factory WSMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSMessage clone() => WSMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSMessage copyWith(void Function(WSMessage) updates) => super.copyWith((message) => updates(message as WSMessage)) as WSMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSMessage create() => WSMessage._();
  WSMessage createEmptyInstance() => create();
  static $pb.PbList<WSMessage> createRepeated() => $pb.PbList<WSMessage>();
  @$core.pragma('dart2js:noInline')
  static WSMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSMessage>(create);
  static WSMessage? _defaultInstance;

  WSMessage_Data whichData() => _WSMessage_DataByTag[$_whichOneof(0)]!;
  void clearData() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  WSType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(WSType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  WSFutureTick get futureTick => $_getN(1);
  @$pb.TagNumber(2)
  set futureTick(WSFutureTick v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFutureTick() => $_has(1);
  @$pb.TagNumber(2)
  void clearFutureTick() => clearField(2);
  @$pb.TagNumber(2)
  WSFutureTick ensureFutureTick() => $_ensure(1);

  @$pb.TagNumber(3)
  WSFutureOrder get futureOrder => $_getN(2);
  @$pb.TagNumber(3)
  set futureOrder(WSFutureOrder v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFutureOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearFutureOrder() => clearField(3);
  @$pb.TagNumber(3)
  WSFutureOrder ensureFutureOrder() => $_ensure(2);

  @$pb.TagNumber(4)
  WSPeriodTradeVolume get periodTradeVolume => $_getN(3);
  @$pb.TagNumber(4)
  set periodTradeVolume(WSPeriodTradeVolume v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPeriodTradeVolume() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodTradeVolume() => clearField(4);
  @$pb.TagNumber(4)
  WSPeriodTradeVolume ensurePeriodTradeVolume() => $_ensure(3);

  @$pb.TagNumber(5)
  WSTradeIndex get tradeIndex => $_getN(4);
  @$pb.TagNumber(5)
  set tradeIndex(WSTradeIndex v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTradeIndex() => $_has(4);
  @$pb.TagNumber(5)
  void clearTradeIndex() => clearField(5);
  @$pb.TagNumber(5)
  WSTradeIndex ensureTradeIndex() => $_ensure(4);

  @$pb.TagNumber(6)
  WSFuturePosition get futurePosition => $_getN(5);
  @$pb.TagNumber(6)
  set futurePosition(WSFuturePosition v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasFuturePosition() => $_has(5);
  @$pb.TagNumber(6)
  void clearFuturePosition() => clearField(6);
  @$pb.TagNumber(6)
  WSFuturePosition ensureFuturePosition() => $_ensure(5);

  @$pb.TagNumber(7)
  WSAssitStatus get assitStatus => $_getN(6);
  @$pb.TagNumber(7)
  set assitStatus(WSAssitStatus v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasAssitStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssitStatus() => clearField(7);
  @$pb.TagNumber(7)
  WSAssitStatus ensureAssitStatus() => $_ensure(6);

  @$pb.TagNumber(8)
  WSErrMessage get errMessage => $_getN(7);
  @$pb.TagNumber(8)
  set errMessage(WSErrMessage v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasErrMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearErrMessage() => clearField(8);
  @$pb.TagNumber(8)
  WSErrMessage ensureErrMessage() => $_ensure(7);
}

class WSErrMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSErrMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errCode')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'response')
    ..hasRequiredFields = false
  ;

  WSErrMessage._() : super();
  factory WSErrMessage({
    $fixnum.Int64? errCode,
    $core.String? response,
  }) {
    final _result = create();
    if (errCode != null) {
      _result.errCode = errCode;
    }
    if (response != null) {
      _result.response = response;
    }
    return _result;
  }
  factory WSErrMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSErrMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSErrMessage clone() => WSErrMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSErrMessage copyWith(void Function(WSErrMessage) updates) => super.copyWith((message) => updates(message as WSErrMessage)) as WSErrMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSErrMessage create() => WSErrMessage._();
  WSErrMessage createEmptyInstance() => create();
  static $pb.PbList<WSErrMessage> createRepeated() => $pb.PbList<WSErrMessage>();
  @$core.pragma('dart2js:noInline')
  static WSErrMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSErrMessage>(create);
  static WSErrMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get errCode => $_getI64(0);
  @$pb.TagNumber(1)
  set errCode($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get response => $_getSZ(1);
  @$pb.TagNumber(2)
  set response($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponse() => clearField(2);
}

class WSFutureOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSFutureOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..aOM<WSOrder>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'baseOrder', subBuilder: WSOrder.create)
    ..hasRequiredFields = false
  ;

  WSFutureOrder._() : super();
  factory WSFutureOrder({
    $core.String? code,
    WSOrder? baseOrder,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (baseOrder != null) {
      _result.baseOrder = baseOrder;
    }
    return _result;
  }
  factory WSFutureOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSFutureOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSFutureOrder clone() => WSFutureOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSFutureOrder copyWith(void Function(WSFutureOrder) updates) => super.copyWith((message) => updates(message as WSFutureOrder)) as WSFutureOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSFutureOrder create() => WSFutureOrder._();
  WSFutureOrder createEmptyInstance() => create();
  static $pb.PbList<WSFutureOrder> createRepeated() => $pb.PbList<WSFutureOrder>();
  @$core.pragma('dart2js:noInline')
  static WSFutureOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSFutureOrder>(create);
  static WSFutureOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  WSOrder get baseOrder => $_getN(1);
  @$pb.TagNumber(2)
  set baseOrder(WSOrder v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseOrder() => clearField(2);
  @$pb.TagNumber(2)
  WSOrder ensureBaseOrder() => $_ensure(1);
}

class WSOrder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSOrder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orderTime')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'action')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.OD)
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeTime')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tickTime')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..hasRequiredFields = false
  ;

  WSOrder._() : super();
  factory WSOrder({
    $core.String? orderId,
    $fixnum.Int64? status,
    $core.String? orderTime,
    $fixnum.Int64? action,
    $core.double? price,
    $fixnum.Int64? quantity,
    $core.String? tradeTime,
    $core.String? tickTime,
    $core.String? groupId,
  }) {
    final _result = create();
    if (orderId != null) {
      _result.orderId = orderId;
    }
    if (status != null) {
      _result.status = status;
    }
    if (orderTime != null) {
      _result.orderTime = orderTime;
    }
    if (action != null) {
      _result.action = action;
    }
    if (price != null) {
      _result.price = price;
    }
    if (quantity != null) {
      _result.quantity = quantity;
    }
    if (tradeTime != null) {
      _result.tradeTime = tradeTime;
    }
    if (tickTime != null) {
      _result.tickTime = tickTime;
    }
    if (groupId != null) {
      _result.groupId = groupId;
    }
    return _result;
  }
  factory WSOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSOrder clone() => WSOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSOrder copyWith(void Function(WSOrder) updates) => super.copyWith((message) => updates(message as WSOrder)) as WSOrder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSOrder create() => WSOrder._();
  WSOrder createEmptyInstance() => create();
  static $pb.PbList<WSOrder> createRepeated() => $pb.PbList<WSOrder>();
  @$core.pragma('dart2js:noInline')
  static WSOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSOrder>(create);
  static WSOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get status => $_getI64(1);
  @$pb.TagNumber(2)
  set status($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderTime($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOrderTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderTime() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get action => $_getI64(3);
  @$pb.TagNumber(4)
  set action($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get price => $_getN(4);
  @$pb.TagNumber(5)
  set price($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get quantity => $_getI64(5);
  @$pb.TagNumber(6)
  set quantity($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get tradeTime => $_getSZ(6);
  @$pb.TagNumber(7)
  set tradeTime($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTradeTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearTradeTime() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get tickTime => $_getSZ(7);
  @$pb.TagNumber(8)
  set tickTime($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTickTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearTickTime() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get groupId => $_getSZ(8);
  @$pb.TagNumber(9)
  set groupId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasGroupId() => $_has(8);
  @$pb.TagNumber(9)
  void clearGroupId() => clearField(9);
}

class WSFutureTick extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSFutureTick', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tickTime')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'open', $pb.PbFieldType.OD)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'underlyingPrice', $pb.PbFieldType.OD)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bidSideTotalVol')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'askSideTotalVol')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avgPrice', $pb.PbFieldType.OD)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'close', $pb.PbFieldType.OD)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'high', $pb.PbFieldType.OD)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'low', $pb.PbFieldType.OD)
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..a<$core.double>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalAmount', $pb.PbFieldType.OD)
    ..aInt64(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volume')
    ..aInt64(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalVolume')
    ..aInt64(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tickType')
    ..aInt64(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chgType')
    ..a<$core.double>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priceChg', $pb.PbFieldType.OD)
    ..a<$core.double>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pctChg', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  WSFutureTick._() : super();
  factory WSFutureTick({
    $core.String? code,
    $core.String? tickTime,
    $core.double? open,
    $core.double? underlyingPrice,
    $fixnum.Int64? bidSideTotalVol,
    $fixnum.Int64? askSideTotalVol,
    $core.double? avgPrice,
    $core.double? close,
    $core.double? high,
    $core.double? low,
    $core.double? amount,
    $core.double? totalAmount,
    $fixnum.Int64? volume,
    $fixnum.Int64? totalVolume,
    $fixnum.Int64? tickType,
    $fixnum.Int64? chgType,
    $core.double? priceChg,
    $core.double? pctChg,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (tickTime != null) {
      _result.tickTime = tickTime;
    }
    if (open != null) {
      _result.open = open;
    }
    if (underlyingPrice != null) {
      _result.underlyingPrice = underlyingPrice;
    }
    if (bidSideTotalVol != null) {
      _result.bidSideTotalVol = bidSideTotalVol;
    }
    if (askSideTotalVol != null) {
      _result.askSideTotalVol = askSideTotalVol;
    }
    if (avgPrice != null) {
      _result.avgPrice = avgPrice;
    }
    if (close != null) {
      _result.close = close;
    }
    if (high != null) {
      _result.high = high;
    }
    if (low != null) {
      _result.low = low;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (totalAmount != null) {
      _result.totalAmount = totalAmount;
    }
    if (volume != null) {
      _result.volume = volume;
    }
    if (totalVolume != null) {
      _result.totalVolume = totalVolume;
    }
    if (tickType != null) {
      _result.tickType = tickType;
    }
    if (chgType != null) {
      _result.chgType = chgType;
    }
    if (priceChg != null) {
      _result.priceChg = priceChg;
    }
    if (pctChg != null) {
      _result.pctChg = pctChg;
    }
    return _result;
  }
  factory WSFutureTick.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSFutureTick.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSFutureTick clone() => WSFutureTick()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSFutureTick copyWith(void Function(WSFutureTick) updates) => super.copyWith((message) => updates(message as WSFutureTick)) as WSFutureTick; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSFutureTick create() => WSFutureTick._();
  WSFutureTick createEmptyInstance() => create();
  static $pb.PbList<WSFutureTick> createRepeated() => $pb.PbList<WSFutureTick>();
  @$core.pragma('dart2js:noInline')
  static WSFutureTick getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSFutureTick>(create);
  static WSFutureTick? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get tickTime => $_getSZ(1);
  @$pb.TagNumber(2)
  set tickTime($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTickTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTickTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get open => $_getN(2);
  @$pb.TagNumber(3)
  set open($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOpen() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpen() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get underlyingPrice => $_getN(3);
  @$pb.TagNumber(4)
  set underlyingPrice($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnderlyingPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnderlyingPrice() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get bidSideTotalVol => $_getI64(4);
  @$pb.TagNumber(5)
  set bidSideTotalVol($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBidSideTotalVol() => $_has(4);
  @$pb.TagNumber(5)
  void clearBidSideTotalVol() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get askSideTotalVol => $_getI64(5);
  @$pb.TagNumber(6)
  set askSideTotalVol($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAskSideTotalVol() => $_has(5);
  @$pb.TagNumber(6)
  void clearAskSideTotalVol() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get avgPrice => $_getN(6);
  @$pb.TagNumber(7)
  set avgPrice($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAvgPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvgPrice() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get close => $_getN(7);
  @$pb.TagNumber(8)
  set close($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasClose() => $_has(7);
  @$pb.TagNumber(8)
  void clearClose() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get high => $_getN(8);
  @$pb.TagNumber(9)
  set high($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasHigh() => $_has(8);
  @$pb.TagNumber(9)
  void clearHigh() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get low => $_getN(9);
  @$pb.TagNumber(10)
  set low($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasLow() => $_has(9);
  @$pb.TagNumber(10)
  void clearLow() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get amount => $_getN(10);
  @$pb.TagNumber(11)
  set amount($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAmount() => $_has(10);
  @$pb.TagNumber(11)
  void clearAmount() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get totalAmount => $_getN(11);
  @$pb.TagNumber(12)
  set totalAmount($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasTotalAmount() => $_has(11);
  @$pb.TagNumber(12)
  void clearTotalAmount() => clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get volume => $_getI64(12);
  @$pb.TagNumber(13)
  set volume($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasVolume() => $_has(12);
  @$pb.TagNumber(13)
  void clearVolume() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get totalVolume => $_getI64(13);
  @$pb.TagNumber(14)
  set totalVolume($fixnum.Int64 v) { $_setInt64(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasTotalVolume() => $_has(13);
  @$pb.TagNumber(14)
  void clearTotalVolume() => clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get tickType => $_getI64(14);
  @$pb.TagNumber(15)
  set tickType($fixnum.Int64 v) { $_setInt64(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasTickType() => $_has(14);
  @$pb.TagNumber(15)
  void clearTickType() => clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get chgType => $_getI64(15);
  @$pb.TagNumber(16)
  set chgType($fixnum.Int64 v) { $_setInt64(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasChgType() => $_has(15);
  @$pb.TagNumber(16)
  void clearChgType() => clearField(16);

  @$pb.TagNumber(17)
  $core.double get priceChg => $_getN(16);
  @$pb.TagNumber(17)
  set priceChg($core.double v) { $_setDouble(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasPriceChg() => $_has(16);
  @$pb.TagNumber(17)
  void clearPriceChg() => clearField(17);

  @$pb.TagNumber(18)
  $core.double get pctChg => $_getN(17);
  @$pb.TagNumber(18)
  set pctChg($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasPctChg() => $_has(17);
  @$pb.TagNumber(18)
  void clearPctChg() => clearField(18);
}

class OutInVolume extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OutInVolume', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outVolume')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inVolume')
    ..hasRequiredFields = false
  ;

  OutInVolume._() : super();
  factory OutInVolume({
    $fixnum.Int64? outVolume,
    $fixnum.Int64? inVolume,
  }) {
    final _result = create();
    if (outVolume != null) {
      _result.outVolume = outVolume;
    }
    if (inVolume != null) {
      _result.inVolume = inVolume;
    }
    return _result;
  }
  factory OutInVolume.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OutInVolume.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OutInVolume clone() => OutInVolume()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OutInVolume copyWith(void Function(OutInVolume) updates) => super.copyWith((message) => updates(message as OutInVolume)) as OutInVolume; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OutInVolume create() => OutInVolume._();
  OutInVolume createEmptyInstance() => create();
  static $pb.PbList<OutInVolume> createRepeated() => $pb.PbList<OutInVolume>();
  @$core.pragma('dart2js:noInline')
  static OutInVolume getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OutInVolume>(create);
  static OutInVolume? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get outVolume => $_getI64(0);
  @$pb.TagNumber(1)
  set outVolume($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOutVolume() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutVolume() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get inVolume => $_getI64(1);
  @$pb.TagNumber(2)
  set inVolume($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInVolume() => $_has(1);
  @$pb.TagNumber(2)
  void clearInVolume() => clearField(2);
}

class WSPeriodTradeVolume extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSPeriodTradeVolume', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOM<OutInVolume>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firstPeriod', subBuilder: OutInVolume.create)
    ..aOM<OutInVolume>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secondPeriod', subBuilder: OutInVolume.create)
    ..aOM<OutInVolume>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'thirdPeriod', subBuilder: OutInVolume.create)
    ..aOM<OutInVolume>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fourthPeriod', subBuilder: OutInVolume.create)
    ..hasRequiredFields = false
  ;

  WSPeriodTradeVolume._() : super();
  factory WSPeriodTradeVolume({
    OutInVolume? firstPeriod,
    OutInVolume? secondPeriod,
    OutInVolume? thirdPeriod,
    OutInVolume? fourthPeriod,
  }) {
    final _result = create();
    if (firstPeriod != null) {
      _result.firstPeriod = firstPeriod;
    }
    if (secondPeriod != null) {
      _result.secondPeriod = secondPeriod;
    }
    if (thirdPeriod != null) {
      _result.thirdPeriod = thirdPeriod;
    }
    if (fourthPeriod != null) {
      _result.fourthPeriod = fourthPeriod;
    }
    return _result;
  }
  factory WSPeriodTradeVolume.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSPeriodTradeVolume.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSPeriodTradeVolume clone() => WSPeriodTradeVolume()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSPeriodTradeVolume copyWith(void Function(WSPeriodTradeVolume) updates) => super.copyWith((message) => updates(message as WSPeriodTradeVolume)) as WSPeriodTradeVolume; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSPeriodTradeVolume create() => WSPeriodTradeVolume._();
  WSPeriodTradeVolume createEmptyInstance() => create();
  static $pb.PbList<WSPeriodTradeVolume> createRepeated() => $pb.PbList<WSPeriodTradeVolume>();
  @$core.pragma('dart2js:noInline')
  static WSPeriodTradeVolume getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSPeriodTradeVolume>(create);
  static WSPeriodTradeVolume? _defaultInstance;

  @$pb.TagNumber(1)
  OutInVolume get firstPeriod => $_getN(0);
  @$pb.TagNumber(1)
  set firstPeriod(OutInVolume v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFirstPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstPeriod() => clearField(1);
  @$pb.TagNumber(1)
  OutInVolume ensureFirstPeriod() => $_ensure(0);

  @$pb.TagNumber(2)
  OutInVolume get secondPeriod => $_getN(1);
  @$pb.TagNumber(2)
  set secondPeriod(OutInVolume v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSecondPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecondPeriod() => clearField(2);
  @$pb.TagNumber(2)
  OutInVolume ensureSecondPeriod() => $_ensure(1);

  @$pb.TagNumber(3)
  OutInVolume get thirdPeriod => $_getN(2);
  @$pb.TagNumber(3)
  set thirdPeriod(OutInVolume v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasThirdPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearThirdPeriod() => clearField(3);
  @$pb.TagNumber(3)
  OutInVolume ensureThirdPeriod() => $_ensure(2);

  @$pb.TagNumber(4)
  OutInVolume get fourthPeriod => $_getN(3);
  @$pb.TagNumber(4)
  set fourthPeriod(OutInVolume v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFourthPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearFourthPeriod() => clearField(4);
  @$pb.TagNumber(4)
  OutInVolume ensureFourthPeriod() => $_ensure(3);
}

class WSTradeIndex extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSTradeIndex', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOM<WSStockSnapShot>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tse', subBuilder: WSStockSnapShot.create)
    ..aOM<WSStockSnapShot>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'otc', subBuilder: WSStockSnapShot.create)
    ..aOM<WSYahooPrice>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nasdaq', subBuilder: WSYahooPrice.create)
    ..aOM<WSYahooPrice>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nf', subBuilder: WSYahooPrice.create)
    ..hasRequiredFields = false
  ;

  WSTradeIndex._() : super();
  factory WSTradeIndex({
    WSStockSnapShot? tse,
    WSStockSnapShot? otc,
    WSYahooPrice? nasdaq,
    WSYahooPrice? nf,
  }) {
    final _result = create();
    if (tse != null) {
      _result.tse = tse;
    }
    if (otc != null) {
      _result.otc = otc;
    }
    if (nasdaq != null) {
      _result.nasdaq = nasdaq;
    }
    if (nf != null) {
      _result.nf = nf;
    }
    return _result;
  }
  factory WSTradeIndex.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSTradeIndex.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSTradeIndex clone() => WSTradeIndex()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSTradeIndex copyWith(void Function(WSTradeIndex) updates) => super.copyWith((message) => updates(message as WSTradeIndex)) as WSTradeIndex; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSTradeIndex create() => WSTradeIndex._();
  WSTradeIndex createEmptyInstance() => create();
  static $pb.PbList<WSTradeIndex> createRepeated() => $pb.PbList<WSTradeIndex>();
  @$core.pragma('dart2js:noInline')
  static WSTradeIndex getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSTradeIndex>(create);
  static WSTradeIndex? _defaultInstance;

  @$pb.TagNumber(1)
  WSStockSnapShot get tse => $_getN(0);
  @$pb.TagNumber(1)
  set tse(WSStockSnapShot v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTse() => $_has(0);
  @$pb.TagNumber(1)
  void clearTse() => clearField(1);
  @$pb.TagNumber(1)
  WSStockSnapShot ensureTse() => $_ensure(0);

  @$pb.TagNumber(2)
  WSStockSnapShot get otc => $_getN(1);
  @$pb.TagNumber(2)
  set otc(WSStockSnapShot v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOtc() => $_has(1);
  @$pb.TagNumber(2)
  void clearOtc() => clearField(2);
  @$pb.TagNumber(2)
  WSStockSnapShot ensureOtc() => $_ensure(1);

  @$pb.TagNumber(3)
  WSYahooPrice get nasdaq => $_getN(2);
  @$pb.TagNumber(3)
  set nasdaq(WSYahooPrice v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNasdaq() => $_has(2);
  @$pb.TagNumber(3)
  void clearNasdaq() => clearField(3);
  @$pb.TagNumber(3)
  WSYahooPrice ensureNasdaq() => $_ensure(2);

  @$pb.TagNumber(4)
  WSYahooPrice get nf => $_getN(3);
  @$pb.TagNumber(4)
  set nf(WSYahooPrice v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNf() => $_has(3);
  @$pb.TagNumber(4)
  void clearNf() => clearField(4);
  @$pb.TagNumber(4)
  WSYahooPrice ensureNf() => $_ensure(3);
}

class WSStockSnapShot extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSStockSnapShot', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stockNum')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stockName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'snapTime')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'open', $pb.PbFieldType.OD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'high', $pb.PbFieldType.OD)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'low', $pb.PbFieldType.OD)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'close', $pb.PbFieldType.OD)
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tickType')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priceChg', $pb.PbFieldType.OD)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pctChg', $pb.PbFieldType.OD)
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chgType')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volume')
    ..aInt64(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volumeSum')
    ..aInt64(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aInt64(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountSum')
    ..a<$core.double>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'yesterdayVolume', $pb.PbFieldType.OD)
    ..a<$core.double>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volumeRatio', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  WSStockSnapShot._() : super();
  factory WSStockSnapShot({
    $core.String? stockNum,
    $core.String? stockName,
    $core.String? snapTime,
    $core.double? open,
    $core.double? high,
    $core.double? low,
    $core.double? close,
    $core.String? tickType,
    $core.double? priceChg,
    $core.double? pctChg,
    $core.String? chgType,
    $fixnum.Int64? volume,
    $fixnum.Int64? volumeSum,
    $fixnum.Int64? amount,
    $fixnum.Int64? amountSum,
    $core.double? yesterdayVolume,
    $core.double? volumeRatio,
  }) {
    final _result = create();
    if (stockNum != null) {
      _result.stockNum = stockNum;
    }
    if (stockName != null) {
      _result.stockName = stockName;
    }
    if (snapTime != null) {
      _result.snapTime = snapTime;
    }
    if (open != null) {
      _result.open = open;
    }
    if (high != null) {
      _result.high = high;
    }
    if (low != null) {
      _result.low = low;
    }
    if (close != null) {
      _result.close = close;
    }
    if (tickType != null) {
      _result.tickType = tickType;
    }
    if (priceChg != null) {
      _result.priceChg = priceChg;
    }
    if (pctChg != null) {
      _result.pctChg = pctChg;
    }
    if (chgType != null) {
      _result.chgType = chgType;
    }
    if (volume != null) {
      _result.volume = volume;
    }
    if (volumeSum != null) {
      _result.volumeSum = volumeSum;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (amountSum != null) {
      _result.amountSum = amountSum;
    }
    if (yesterdayVolume != null) {
      _result.yesterdayVolume = yesterdayVolume;
    }
    if (volumeRatio != null) {
      _result.volumeRatio = volumeRatio;
    }
    return _result;
  }
  factory WSStockSnapShot.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSStockSnapShot.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSStockSnapShot clone() => WSStockSnapShot()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSStockSnapShot copyWith(void Function(WSStockSnapShot) updates) => super.copyWith((message) => updates(message as WSStockSnapShot)) as WSStockSnapShot; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSStockSnapShot create() => WSStockSnapShot._();
  WSStockSnapShot createEmptyInstance() => create();
  static $pb.PbList<WSStockSnapShot> createRepeated() => $pb.PbList<WSStockSnapShot>();
  @$core.pragma('dart2js:noInline')
  static WSStockSnapShot getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSStockSnapShot>(create);
  static WSStockSnapShot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stockNum => $_getSZ(0);
  @$pb.TagNumber(1)
  set stockNum($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStockNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearStockNum() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get stockName => $_getSZ(1);
  @$pb.TagNumber(2)
  set stockName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStockName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStockName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get snapTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set snapTime($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSnapTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearSnapTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get open => $_getN(3);
  @$pb.TagNumber(4)
  set open($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOpen() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpen() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get high => $_getN(4);
  @$pb.TagNumber(5)
  set high($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHigh() => $_has(4);
  @$pb.TagNumber(5)
  void clearHigh() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get low => $_getN(5);
  @$pb.TagNumber(6)
  set low($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLow() => $_has(5);
  @$pb.TagNumber(6)
  void clearLow() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get close => $_getN(6);
  @$pb.TagNumber(7)
  set close($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasClose() => $_has(6);
  @$pb.TagNumber(7)
  void clearClose() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get tickType => $_getSZ(7);
  @$pb.TagNumber(8)
  set tickType($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTickType() => $_has(7);
  @$pb.TagNumber(8)
  void clearTickType() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get priceChg => $_getN(8);
  @$pb.TagNumber(9)
  set priceChg($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPriceChg() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriceChg() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get pctChg => $_getN(9);
  @$pb.TagNumber(10)
  set pctChg($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPctChg() => $_has(9);
  @$pb.TagNumber(10)
  void clearPctChg() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get chgType => $_getSZ(10);
  @$pb.TagNumber(11)
  set chgType($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasChgType() => $_has(10);
  @$pb.TagNumber(11)
  void clearChgType() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get volume => $_getI64(11);
  @$pb.TagNumber(12)
  set volume($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasVolume() => $_has(11);
  @$pb.TagNumber(12)
  void clearVolume() => clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get volumeSum => $_getI64(12);
  @$pb.TagNumber(13)
  set volumeSum($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasVolumeSum() => $_has(12);
  @$pb.TagNumber(13)
  void clearVolumeSum() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get amount => $_getI64(13);
  @$pb.TagNumber(14)
  set amount($fixnum.Int64 v) { $_setInt64(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasAmount() => $_has(13);
  @$pb.TagNumber(14)
  void clearAmount() => clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get amountSum => $_getI64(14);
  @$pb.TagNumber(15)
  set amountSum($fixnum.Int64 v) { $_setInt64(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasAmountSum() => $_has(14);
  @$pb.TagNumber(15)
  void clearAmountSum() => clearField(15);

  @$pb.TagNumber(16)
  $core.double get yesterdayVolume => $_getN(15);
  @$pb.TagNumber(16)
  set yesterdayVolume($core.double v) { $_setDouble(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasYesterdayVolume() => $_has(15);
  @$pb.TagNumber(16)
  void clearYesterdayVolume() => clearField(16);

  @$pb.TagNumber(17)
  $core.double get volumeRatio => $_getN(16);
  @$pb.TagNumber(17)
  set volumeRatio($core.double v) { $_setDouble(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasVolumeRatio() => $_has(16);
  @$pb.TagNumber(17)
  void clearVolumeRatio() => clearField(17);
}

class WSYahooPrice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSYahooPrice', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'last', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.OD)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  WSYahooPrice._() : super();
  factory WSYahooPrice({
    $core.double? last,
    $core.double? price,
    $core.String? updatedAt,
  }) {
    final _result = create();
    if (last != null) {
      _result.last = last;
    }
    if (price != null) {
      _result.price = price;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory WSYahooPrice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSYahooPrice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSYahooPrice clone() => WSYahooPrice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSYahooPrice copyWith(void Function(WSYahooPrice) updates) => super.copyWith((message) => updates(message as WSYahooPrice)) as WSYahooPrice; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSYahooPrice create() => WSYahooPrice._();
  WSYahooPrice createEmptyInstance() => create();
  static $pb.PbList<WSYahooPrice> createRepeated() => $pb.PbList<WSYahooPrice>();
  @$core.pragma('dart2js:noInline')
  static WSYahooPrice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSYahooPrice>(create);
  static WSYahooPrice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get last => $_getN(0);
  @$pb.TagNumber(1)
  set last($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLast() => $_has(0);
  @$pb.TagNumber(1)
  void clearLast() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get price => $_getN(1);
  @$pb.TagNumber(2)
  set price($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get updatedAt => $_getSZ(2);
  @$pb.TagNumber(3)
  set updatedAt($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAt() => clearField(3);
}

class WSFuturePosition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSFuturePosition', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..pc<Position>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', $pb.PbFieldType.PM, subBuilder: Position.create)
    ..hasRequiredFields = false
  ;

  WSFuturePosition._() : super();
  factory WSFuturePosition({
    $core.Iterable<Position>? position,
  }) {
    final _result = create();
    if (position != null) {
      _result.position.addAll(position);
    }
    return _result;
  }
  factory WSFuturePosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSFuturePosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSFuturePosition clone() => WSFuturePosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSFuturePosition copyWith(void Function(WSFuturePosition) updates) => super.copyWith((message) => updates(message as WSFuturePosition)) as WSFuturePosition; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSFuturePosition create() => WSFuturePosition._();
  WSFuturePosition createEmptyInstance() => create();
  static $pb.PbList<WSFuturePosition> createRepeated() => $pb.PbList<WSFuturePosition>();
  @$core.pragma('dart2js:noInline')
  static WSFuturePosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSFuturePosition>(create);
  static WSFuturePosition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Position> get position => $_getList(0);
}

class Position extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Position', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'direction')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'price', $pb.PbFieldType.OD)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastPrice', $pb.PbFieldType.OD)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pnl', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Position._() : super();
  factory Position({
    $core.String? code,
    $core.String? direction,
    $fixnum.Int64? quantity,
    $core.double? price,
    $core.double? lastPrice,
    $core.double? pnl,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (direction != null) {
      _result.direction = direction;
    }
    if (quantity != null) {
      _result.quantity = quantity;
    }
    if (price != null) {
      _result.price = price;
    }
    if (lastPrice != null) {
      _result.lastPrice = lastPrice;
    }
    if (pnl != null) {
      _result.pnl = pnl;
    }
    return _result;
  }
  factory Position.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Position.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Position clone() => Position()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Position copyWith(void Function(Position) updates) => super.copyWith((message) => updates(message as Position)) as Position; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get direction => $_getSZ(1);
  @$pb.TagNumber(2)
  set direction($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get quantity => $_getI64(2);
  @$pb.TagNumber(3)
  set quantity($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get lastPrice => $_getN(4);
  @$pb.TagNumber(5)
  set lastPrice($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLastPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get pnl => $_getN(5);
  @$pb.TagNumber(6)
  set pnl($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPnl() => $_has(5);
  @$pb.TagNumber(6)
  void clearPnl() => clearField(6);
}

class WSAssitStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WSAssitStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'sinopac_forwarder'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'running')
    ..hasRequiredFields = false
  ;

  WSAssitStatus._() : super();
  factory WSAssitStatus({
    $core.bool? running,
  }) {
    final _result = create();
    if (running != null) {
      _result.running = running;
    }
    return _result;
  }
  factory WSAssitStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WSAssitStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WSAssitStatus clone() => WSAssitStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WSAssitStatus copyWith(void Function(WSAssitStatus) updates) => super.copyWith((message) => updates(message as WSAssitStatus)) as WSAssitStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WSAssitStatus create() => WSAssitStatus._();
  WSAssitStatus createEmptyInstance() => create();
  static $pb.PbList<WSAssitStatus> createRepeated() => $pb.PbList<WSAssitStatus>();
  @$core.pragma('dart2js:noInline')
  static WSAssitStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WSAssitStatus>(create);
  static WSAssitStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get running => $_getBF(0);
  @$pb.TagNumber(1)
  set running($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRunning() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunning() => clearField(1);
}

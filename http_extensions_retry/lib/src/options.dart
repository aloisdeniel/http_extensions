import 'dart:async';
import 'package:http/http.dart';

typedef RetryEvaluator = FutureOr<bool> Function(
    dynamic error, StreamedResponse? response);

class RetryOptions {
  /// The number of retry in case of an error
  final int retries;

  /// The interval before a retry.
  final Duration retryInterval;

  /// Evaluating if a retry is necessary.regarding the error.
  ///
  /// It can be a good candidate for additional operations too, like
  /// updating authentication token in case of a unauthorized error (be careful
  /// with concurrency though).
  ///
  /// Defaults to [defaultRetryEvaluator].
  RetryEvaluator get retryEvaluator => _retryEvaluator ?? defaultRetryEvaluator;

  final RetryEvaluator? _retryEvaluator;

  const RetryOptions(
      {this.retries = 3,
      RetryEvaluator? retryEvaluator,
      this.retryInterval = const Duration(seconds: 5)})
      : assert(retries != null),
        assert(retryInterval != null),
        this._retryEvaluator = retryEvaluator;

  factory RetryOptions.noRetry() {
    return RetryOptions(
      retries: 0,
    );
  }

  RetryOptions copyWith({
    int? retries,
    Duration? retryInterval,
    RetryEvaluator? retryEvaluator,
  }) =>
      RetryOptions(
        retries: retries ?? this.retries,
        retryEvaluator: retryEvaluator ?? this.retryEvaluator,
        retryInterval: retryInterval ?? this.retryInterval,
      );

  /// Returns [true] only if the response hasn't been cancelled or got
  /// a bas status code.
  static FutureOr<bool> defaultRetryEvaluator(
      dynamic error, StreamedResponse? response) {
    return error != null;
  }
}

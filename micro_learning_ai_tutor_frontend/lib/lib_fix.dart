/// Utility used to simulate async repositories without delay.
Future<T> inlineFuture<T>(T value) => Future<T>.value(value);

abstract class DataState<T> {
  final T? data;
  final int? statusCode;

  const DataState({this.data, this.statusCode});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailure<T> extends DataState<T> {
  const DataFailure(int statusCode) : super(statusCode: statusCode);
}

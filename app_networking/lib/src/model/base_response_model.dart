import 'package:dependency/dependency.dart';

part 'base_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponseModel<T> {
  const BaseResponseModel(this.data, this.message);

  factory BaseResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) => _$BaseResponseModelFromJson(json, fromJsonT);

  @JsonKey(name: 'data')
  final T? data;

  @JsonKey(name: 'message')
  final String message;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseModelToJson(this, toJsonT);
}

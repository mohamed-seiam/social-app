part of 'feeds_cubit.dart';

abstract class FeedsState {}

class FeedsInitial extends FeedsState {}
class FeedsLoading extends FeedsState {}
class FeedsSuccess extends FeedsState {}
class FeedsFailure extends FeedsState {}
class GetFeedsSuccess extends FeedsState {}
class FeedsPickedImageSuccess extends FeedsState {}
class FeedsPickedImageFailure extends FeedsState {}
class FeedsPickedVideoSuccess extends FeedsState {}
class FeedsPickedVideoFailure extends FeedsState {}
class FeedsRemovePickedImage extends FeedsState {}
class FeedsRemovePickedVideo extends FeedsState {}



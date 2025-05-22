

import 'package:flutter_riverpod/flutter_riverpod.dart';
class PostPreviewState {
  final double leftPosition;
  final double topPosition;
  final String filterName;

  PostPreviewState({
    required this.leftPosition,
    required this.topPosition,
    required this.filterName,
  });

  PostPreviewState copyWith({
    double? leftPosition,
    double? topPosition,
    String? filterName,
  }) {
    return PostPreviewState(
      leftPosition: leftPosition ?? this.leftPosition,
      topPosition: topPosition ?? this.topPosition,
      filterName: filterName ?? this.filterName,
    );
  }
}


class PostPreviewViewmodel extends Notifier<PostPreviewState>{
  @override
  build() {
    return PostPreviewState( leftPosition: 0, topPosition: 0, filterName: 'default');
  }

  void setPosition({required double leftPostion, required  double topPosition}){
    state = state.copyWith(leftPosition: leftPostion, topPosition: topPosition);
  }

  void setFilter(String filterName){
    state = state.copyWith(filterName: filterName);
  }
}
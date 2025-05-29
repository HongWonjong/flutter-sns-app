import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/report/report_provider.dart';
import 'package:uuid/uuid.dart';

class ReportState {
  String reason;
  String type;
  ReportState({this.reason = "", this.type = 'post'});

  ReportState copyWith({String? reason, String? type}) {
    return ReportState(reason: reason ?? this.reason, type: type ?? this.type);
  }
}

class ReportViewmodel extends AutoDisposeNotifier<ReportState> {
  @override
  build() {
    return ReportState();
  }

  Future<bool> sendReport() async {
    String id = Uuid().v4();
    final result = await ref
        .read(sendReportUsecase)
        .execute(id: id, reason: state.reason, type: state.type);
    return result;
  }

  void setType(String type) {
    state = state.copyWith(type: type);
  }

  void setReason(String reason){
    state = state.copyWith(reason: reason);
  }
}

final reportViewmodel =
    AutoDisposeNotifierProvider<ReportViewmodel, ReportState>(
  () => ReportViewmodel(),
);

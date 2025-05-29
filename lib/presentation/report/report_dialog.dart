import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/report/report_provider.dart';
import 'package:flutter_sns_app/presentation/report/viewmodels/report_viewmodel.dart';

class ReportDialog extends ConsumerStatefulWidget {
  const ReportDialog({super.key, required this.type});
  final String type;
  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportViewmodel.notifier).setType(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportVm = ref.read(reportViewmodel.notifier);
    return AlertDialog(
      title: const Text('신고하기'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: '신고 사유를 입력하세요'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            reportVm.setReason(_controller.text);

            final success = await reportVm.sendReport();

            if (!mounted) return;
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success ? '신고가 접수되었습니다.' : '신고에 실패했습니다. 다시 시도해주세요.',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          },
          child: const Text('신고'),
        ),
      ],
    );
  }
}

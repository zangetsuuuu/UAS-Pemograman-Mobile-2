import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_str.dart';

/// Lottie assets
String lottieURL = 'assets/lottie/3.json';

/// Empty Title or Subtitle Textfield warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'Isi semua inputan terlebih dahulu',
    corner: 16.0,
    duration: 2500,
    padding: const EdgeInsets.all(20),
  );
}

/// Update warning
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'Tidak ada perubahan yang dilakukan',
    corner: 16.0,
    duration: 2500,
    padding: const EdgeInsets.all(20),
  );
}

/// No task warning
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: AppStr.oopsMsg,
      message: 'Tidak ada tugas yang dapat dihapus',
      buttonText: 'Ok', onTapDismiss: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.warning);
}

/// Delete all task
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(context,
      title: AppStr.areYouSure,
      message: 'Tindakan ini akan menghapus semua tugas',
      confirmButtonText: 'Hapus',
      cancelButtonText: 'Batal', onTapConfirm: () {
    BaseWidget.of(context).dataStore.box.clear();
    Navigator.pop(context);
  }, onTapCancel: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.error, barrierDismissible: false);
}

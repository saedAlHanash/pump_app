

import '../app/app_widget.dart';
import '../util/abstraction.dart';
import '../util/snack_bar_message.dart';



showErrorFromApi(AbstractCubit state) {
  if (ctx == null) return;

  NoteMessage.showAwesomeError(context: ctx!, message: state.error);
}

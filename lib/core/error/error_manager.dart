

import '../../generated/l10n.dart';
import '../../router/app_router.dart';
import '../app/app_widget.dart';
import '../injection/injection_container.dart';
import '../util/abstraction.dart';
import '../util/shared_preferences.dart';
import '../util/snack_bar_message.dart';



showErrorFromApi(AbstractCubit state) {
  if (ctx == null) return;

  NoteMessage.showAwesomeError(context: ctx!, message: state.error);
}

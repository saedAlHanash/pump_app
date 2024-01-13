import 'package:pump_app/core/widgets/spinner_widget.dart';


abstract class AbstractModel {
  AbstractModel fromJson(Map<String, dynamic> map);

  Map<String, dynamic> toJson();

  SpinnerItem get getSpinnerItem;


}

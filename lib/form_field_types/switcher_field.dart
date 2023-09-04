

import 'package:dynamic_forms/form_field_configuration.dart';

final class SwitcherFieldConfiguration extends FormFieldConfiguration {

  const SwitcherFieldConfiguration({
    super.label,
  }) : super(
    formType: FormFieldType.switcher,
  );

  factory SwitcherFieldConfiguration.fromJSON(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}
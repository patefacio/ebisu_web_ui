import "dart:io";
import "package:path/path.dart";
import "package:ebisu/ebisu_dart_meta.dart";
import "package:ebisu_web_ui/ebisu_web_ui.dart";
import "package:id/id.dart";

main() {
  var here = dirname(dirname(absolute(Platform.script.path)));
  print(here);
  ComponentLibrary mortgageCalculator =
    componentLibrary('mortgage_calculator')
    ..dependencies = [
      pubdep('fixnum')..version = ">=0.9.0",
      pubdep('money')..path = '/Users/dbdavidson/dev/open_source/money'
    ]
    ..rootPath = here
    ..examples = [ example(idFromString('mortgage_calculator')) ]
    ..components = [
      component('money_input')
      ..imports = [
        'package:money/format.dart',
      ]
      ..implClass = (class_('money_input')
          ..members = [
            member('amount_element')..type = 'InputElement',
          ]),
      component('rate_input')
      ..imports = [
        'package:money/format.dart',
      ]
      ..implClass = (class_('rate_input')
          ..members = [
            member('rate_element')..type = 'InputElement',
          ]),
      component('num_with_units_input')
      ..imports = [
        'package:intl/intl.dart',
        'package:money/format.dart',
      ]
      ..implClass = (class_('num_with_units_input')
          ..members = [
            member('value_element')..type = 'InputElement',
            member('units'),
            member('number_format')..type = 'NumberFormat',
          ]),
      component('date_input')
      ..imports = [
        'package:money/format.dart',
      ]
      ..implClass = (class_('date_input')
          ..members = [
            member('date_element')..type = 'InputElement',
          ]),
      component('mortgage_calculator')
      ..imports = [
        'mortgage_details.dart',
        'payment_schedule.dart',
      ]
      ..implClass = (class_('mortgage_calculator')
          ..members = [
            member('mortgage_details')..type = 'MortgageDetails',
            member('payment_schedule')..type = 'PaymentSchedule',
          ]),
      component('mortgage_details')
      ..imports = [
        'package:money/format.dart',
        'package:money/mortgage.dart',
        'money_input.dart', 'rate_input.dart', 'date_input.dart',
        'num_with_units_input.dart'
      ]
      ..implClass = (class_('mortgage_details')
          ..members = [
            member('term_years_input')..type = 'NumWithUnitsInput',
            member('mortgage_amount_input')..type = 'MoneyInput',
            member('rate_input')..type = 'RateInput',
            member('formatted_payment')..isObservable = true,
          ]),
      component('payment_schedule')
      ..imports = [
        'date_input.dart',
        'package:money/format.dart',
        'html',
      ]
      ..implClass = (class_('payment_schedule')
          ..members = [
            member('date_input')..type = 'DateInput',
            member('schedule_table')..type = 'TableElement'
          ])
    ];

      //..extendsElement = 'li',
      //      component('mortgage_prepay'),
      //      component('payment_schedule'),

  mortgageCalculator.generate();
}
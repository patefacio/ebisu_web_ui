library num_with_units_input;

import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";
import "package:intl/intl.dart";
import "package:money/format.dart";

final _logger = new Logger("mortgageCalculator");

@CustomTag("num-with-units-input")
class NumWithUnitsInput extends PolymerElement {
  InputElement valueElement;
  String units;
  NumberFormat numberFormat;

  NumWithUnitsInput.created() : super.created() {
    // custom <NumWithUnitsInput created>

    if(shadowRoot != null) {
      valueElement = shadowRoot.querySelector('#value')
        ..onBlur.listen((evt) => validateValue())
        ..onFocus.listen((evt) => validateValue());
    }

    // end <NumWithUnitsInput created>
  }

  // custom <class NumWithUnitsInput>

  String set label(String s) {
    valueElement.placeholder = s;
  }

  validateValue() {
    if(numberFormat == null) {
      numberFormat =
        new NumberFormat.decimalPattern("en");
    }
    if(valueElement.value.length > 0) {
      valueElement.value =
        "${numberFormat.format(pullNum(valueElement.value))} $units";
    }
  }

  num get number => pullNum(valueElement.value);

  // end <class NumWithUnitsInput>
}



// custom <mortgage_calculator>
// end <mortgage_calculator>

library date_input;

import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";
import "package:money/format.dart";

final _logger = new Logger("mortgageCalculator");

@CustomTag("date-input")
class DateInput extends PolymerElement {
  InputElement dateElement;

  DateInput.created() : super.created() {
    // custom <DateInput created>

    if(shadowRoot != null) {
      dateElement = shadowRoot.querySelector('#date')
        ..onBlur.listen((evt) => validateDate(evt))
        ..onFocus.listen((evt) => validateDate(evt));
    }

    // end <DateInput created>
  }

  // custom <class DateInput>

  String set label(String s) {
    dateElement.placeholder = s;
  }

  validateDate(FocusEvent evt) {
    if(dateElement.value.length > 0) {
      dateElement.value =
        "${dateFormat(pullDate(dateElement.value))}";
    }
  }

  // end <class DateInput>
}



// custom <mortgage_calculator>
// end <mortgage_calculator>

library rate_input;

import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";
import "package:money/format.dart";

final _logger = new Logger("mortgageCalculator");

@CustomTag("rate-input")
class RateInput extends PolymerElement {
  InputElement rateElement;

  RateInput.created() : super.created() {
    // custom <RateInput created>

    if(shadowRoot != null) {
      rateElement = shadowRoot.querySelector('#rate')
        ..onBlur.listen((evt) => validateRate())
        ..onFocus.listen((evt) => validateRate());
    }

    // end <RateInput created>
  }

  // custom <class RateInput>

  String set label(String s) {
    rateElement.placeholder = s;
  }

  validateRate() {
    if(rateElement.value.length > 0) {
      rateElement.value =
        "${percentFormat(pullNum(rateElement.value)/100.0)}";
    }
  }

  num get rate {
    return pullNum(rateElement.value);
  }

  // end <class RateInput>
}



// custom <mortgage_calculator>
// end <mortgage_calculator>

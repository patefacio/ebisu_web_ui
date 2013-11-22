library money_input;

import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";
import "package:money/format.dart";

final _logger = new Logger("mortgageCalculator");

@CustomTag("money-input")
class MoneyInput extends PolymerElement {
  InputElement amountElement;

  MoneyInput.created() : super.created() {
    // custom <MoneyInput created>

    if(shadowRoot != null) {
      amountElement = shadowRoot.querySelector('#money-amount')
        ..onBlur.listen((evt) => validateAmount(evt))
        ..onFocus.listen((evt) => validateAmount(evt));

      amountElement.classes.add('fa');
      amountElement.classes.add('fa-filter');
    }

    // end <MoneyInput created>
  }

  // custom <class MoneyInput>

  String set label(String s) {
    amountElement.placeholder = s;
  }

  validateAmount(FocusEvent evt) {
    if(amountElement.value.length > 0) {
      amountElement.value =
        "${moneyFormat(pullNum(amountElement.value))}";
    }
  }

  num get amount => pullNum(amountElement.value);

  // end <class MoneyInput>
}



// custom <mortgage_calculator>


// end <mortgage_calculator>

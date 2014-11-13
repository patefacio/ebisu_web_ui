library money_input;
import 'dart:html' hide Timeline;
import 'package:logging/logging.dart';
import 'package:money/format.dart';
import 'package:polymer/polymer.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("moneyInput");

@CustomTag("money-input")
class MoneyInput extends PolymerElement {

  InputElement amountElement;

  MoneyInput.created() : super.created() {
    _logger.fine('MoneyInput created sr => $shadowRoot');
    // custom <MoneyInput created>

    if(shadowRoot != null) {
      amountElement = shadowRoot.querySelector('#money-amount')
        ..onBlur.listen((evt) => validateAmount(evt))
        ..onFocus.listen((evt) => validateAmount(evt));
    }

    // end <MoneyInput created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('MoneyInput domReady with sr => $shadowRoot');
    // custom <MoneyInput domReady>
    // end <MoneyInput domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('MoneyInput ready with sr => $shadowRoot');
    // custom <MoneyInput ready>
    // end <MoneyInput ready>

  }

  @override
  void attached() {
    // custom <MoneyInput pre-attached>
    // end <MoneyInput pre-attached>

    super.attached();
    _logger.fine('MoneyInput attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <MoneyInput attached>
    // end <MoneyInput attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(MoneyInput)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class MoneyInput>

  //bool get applyAuthorStyles => true;

  set label(String s) {
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
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <money_input>
// end <money_input>

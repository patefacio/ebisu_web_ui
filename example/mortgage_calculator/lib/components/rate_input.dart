library rate_input;
import 'dart:html' hide Timeline;
import 'package:logging/logging.dart';
import 'package:money/format.dart';
import 'package:polymer/polymer.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("rateInput");

@CustomTag("rate-input")
class RateInput extends PolymerElement {

  InputElement rateElement;

  RateInput.created() : super.created() {
    _logger.fine('RateInput created sr => $shadowRoot');
    // custom <RateInput created>

    if(shadowRoot != null) {
      rateElement = shadowRoot.querySelector('#rate')
        ..onBlur.listen((evt) => validateRate())
        ..onFocus.listen((evt) => validateRate());
    }

    // end <RateInput created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('RateInput domReady with sr => $shadowRoot');
    // custom <RateInput domReady>
    // end <RateInput domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('RateInput ready with sr => $shadowRoot');
    // custom <RateInput ready>
    // end <RateInput ready>

  }

  @override
  void attached() {
    // custom <RateInput pre-attached>
    // end <RateInput pre-attached>

    super.attached();
    _logger.fine('RateInput attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <RateInput attached>
    // end <RateInput attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(RateInput)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class RateInput>

  set label(String s) {
    rateElement.placeholder = s;
  }

  validateRate() {
    if(rateElement.value.length > 0) {
      rateElement.value =
        "${percentFormat(pullNum(rateElement.value)/100.0)}";
    }
  }

  num get rate {
    return pullNum(rateElement.value)/100.0;
  }

  // end <class RateInput>
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <rate_input>
// end <rate_input>

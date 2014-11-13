library num_with_units_input;
import 'dart:html' hide Timeline;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:money/format.dart';
import 'package:polymer/polymer.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("numWithUnitsInput");

@CustomTag("num-with-units-input")
class NumWithUnitsInput extends PolymerElement {

  InputElement valueElement;
  String units;
  NumberFormat numberFormat;

  NumWithUnitsInput.created() : super.created() {
    _logger.fine('NumWithUnitsInput created sr => $shadowRoot');
    // custom <NumWithUnitsInput created>

    if(shadowRoot != null) {
      valueElement = shadowRoot.querySelector('#value')
        ..onBlur.listen((evt) => validateValue())
        ..onFocus.listen((evt) => validateValue());
    }

    // end <NumWithUnitsInput created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('NumWithUnitsInput domReady with sr => $shadowRoot');
    // custom <NumWithUnitsInput domReady>
    // end <NumWithUnitsInput domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('NumWithUnitsInput ready with sr => $shadowRoot');
    // custom <NumWithUnitsInput ready>
    // end <NumWithUnitsInput ready>

  }

  @override
  void attached() {
    // custom <NumWithUnitsInput pre-attached>
    // end <NumWithUnitsInput pre-attached>

    super.attached();
    _logger.fine('NumWithUnitsInput attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <NumWithUnitsInput attached>
    // end <NumWithUnitsInput attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(NumWithUnitsInput)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class NumWithUnitsInput>

  set label(String s) {
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
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <num_with_units_input>
// end <num_with_units_input>

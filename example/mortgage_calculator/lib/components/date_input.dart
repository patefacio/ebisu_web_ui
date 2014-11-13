library date_input;
import 'dart:html' hide Timeline;
import 'package:logging/logging.dart';
import 'package:money/format.dart';
import 'package:polymer/polymer.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("dateInput");

@CustomTag("date-input")
class DateInput extends PolymerElement {

  InputElement dateElement;

  DateInput.created() : super.created() {
    _logger.fine('DateInput created sr => $shadowRoot');
    // custom <DateInput created>

    if(shadowRoot != null) {
      dateElement = shadowRoot.querySelector('#date')
        ..onBlur.listen((evt) => validateDate(evt))
        ..onFocus.listen((evt) => validateDate(evt));
    }

    // end <DateInput created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('DateInput domReady with sr => $shadowRoot');
    // custom <DateInput domReady>
    // end <DateInput domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('DateInput ready with sr => $shadowRoot');
    // custom <DateInput ready>
    // end <DateInput ready>

  }

  @override
  void attached() {
    // custom <DateInput pre-attached>
    // end <DateInput pre-attached>

    super.attached();
    _logger.fine('DateInput attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <DateInput attached>
    // end <DateInput attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(DateInput)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class DateInput>

  set label(String s) {
    dateElement.placeholder = s;
  }

  validateDate(FocusEvent evt) {
    if(dateElement.value.length > 0) {
      dateElement.value = "${dateFormat(date)}";
    }
  }

  DateTime get date => pullDate(dateElement.value);

  // end <class DateInput>
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <date_input>
// end <date_input>

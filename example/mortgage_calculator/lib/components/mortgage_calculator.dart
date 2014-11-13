library mortgage_calculator;
import 'dart:html' hide Timeline;
import 'mortgage_details.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'payment_schedule.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("mortgageCalculator");

@CustomTag("mortgage-calculator")
class MortgageCalculator extends PolymerElement {

  MortgageDetails mortgageDetails;
  PaymentSchedule paymentSchedule;

  MortgageCalculator.created() : super.created() {
    _logger.fine('MortgageCalculator created sr => $shadowRoot');
    // custom <MortgageCalculator created>

    if(shadowRoot != null) {
      mortgageDetails = ($['date'] as MortgageDetails);
      paymentSchedule = ($['schedule'] as PaymentSchedule);
    }

    // end <MortgageCalculator created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('MortgageCalculator domReady with sr => $shadowRoot');
    // custom <MortgageCalculator domReady>
    // end <MortgageCalculator domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('MortgageCalculator ready with sr => $shadowRoot');
    // custom <MortgageCalculator ready>
    // end <MortgageCalculator ready>

  }

  @override
  void attached() {
    // custom <MortgageCalculator pre-attached>
    // end <MortgageCalculator pre-attached>

    super.attached();
    _logger.fine('MortgageCalculator attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <MortgageCalculator attached>
    // end <MortgageCalculator attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(MortgageCalculator)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class MortgageCalculator>

  bool get applyAuthorStyles => true;

  // end <class MortgageCalculator>
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <mortgage_calculator>
// end <mortgage_calculator>

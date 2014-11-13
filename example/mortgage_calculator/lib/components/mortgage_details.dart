library mortgage_details;
import 'dart:html' hide Timeline;
import 'date_input.dart';
import 'money_input.dart';
import 'num_with_units_input.dart';
import 'package:logging/logging.dart';
import 'package:money/format.dart';
import 'package:money/mortgage.dart';
import 'package:polymer/polymer.dart';
import 'rate_input.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("mortgageDetails");

@CustomTag("mortgage-details")
class MortgageDetails extends PolymerElement {

  NumWithUnitsInput termYearsInput;
  MoneyInput mortgageAmountInput;
  RateInput rateInput;
  @observable String formattedPayment;

  MortgageDetails.created() : super.created() {
    _logger.fine('MortgageDetails created sr => $shadowRoot');
    // custom <MortgageDetails created>

    if(null == shadowRoot) return;

    (mortgageAmountInput = $["mortgage-amount"] as MoneyInput)
      ..label = r" $ Amount of Loan"
      ..onBlur.listen((_) => recalc())
      ..onFocus.listen((_) => recalc());

    (rateInput = $["rate"] as RateInput)
      ..label = " Rate (%)"
      ..onBlur.listen((_) => recalc())
      ..onFocus.listen((_) => recalc());

    (termYearsInput = $["term-years"] as NumWithUnitsInput)
      ..label = " Term (years)"
      ..units = "years"
      ..onBlur.listen((_) => recalc())
      ..onFocus.listen((_) => recalc());

    recalc();

    // end <MortgageDetails created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('MortgageDetails domReady with sr => $shadowRoot');
    // custom <MortgageDetails domReady>
    // end <MortgageDetails domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('MortgageDetails ready with sr => $shadowRoot');
    // custom <MortgageDetails ready>
    // end <MortgageDetails ready>

  }

  @override
  void attached() {
    // custom <MortgageDetails pre-attached>
    // end <MortgageDetails pre-attached>

    super.attached();
    _logger.fine('MortgageDetails attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <MortgageDetails attached>
    // end <MortgageDetails attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(MortgageDetails)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class MortgageDetails>

  bool get applyAuthorStyles => true;

  void recalc() {
    formattedPayment = moneyFormat(payment);
  }

  num get payment {
    if(null != mortgageAmountInput) {
      num amount = mortgageAmountInput.amount;
      num years = termYearsInput.number;
      num rate = rateInput.rate;
      if(rate == 0 || years == 0) {
        return 0;
      }
      return mortgagePayment(amount, rate, years);
    }
    return 0;
  }

  // end <class MortgageDetails>
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <mortgage_details>
// end <mortgage_details>

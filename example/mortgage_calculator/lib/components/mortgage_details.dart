import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";
import "package:fixnum/fixnum.dart";
import "package:money/format.dart";
import "package:money/mortgage.dart";
import "money_input.dart";
import "rate_input.dart";
import "date_input.dart";
import "num_with_units_input.dart";

final _logger = new Logger("mortgageCalculator");

@CustomTag("mortgage-details")
class MortgageDetails extends PolymerElement {
  NumWithUnitsInput termYearsInput;
  MoneyInput mortgageAmountInput;
  RateInput rateInput;
  DateInput dateInput;
  @observable String formattedPayment;

  MortgageDetails.created() : super.created() {
    // custom <MortgageDetails created>

    if(null == shadowRoot) return;

    (mortgageAmountInput = $["mortgage-amount"])
      ..label = r"$ Amount of Loan"
      ..onBlur.listen((_) => recalc())
      ..onFocus.listen((_) => recalc());

    (rateInput = $["rate"])
      ..label = "Rate (%)"
      ..onBlur.listen((_) => recalc())
      ..onFocus.listen((_) => recalc());

    (termYearsInput = $["term-years"])
      ..label = "Term (years)"
      ..units = "years"
      ..onBlur.listen((_) => recalc())
      ..onFocus.listen((_) => recalc());

    (dateInput = $["date"])..label = "yyyy-MM-dd";

    // end <MortgageDetails created>
  }

  // custom <class MortgageDetails>

  void recalc() {
    formattedPayment = moneyFormat(payment);
    print("Formatted result $formattedPayment");
  }

  num get payment {
    if(null != mortgageAmountInput) {
      num amount = mortgageAmountInput.amount;
      num years = termYearsInput.number;
      num rate = rateInput.rate;
      print("Got $amount, $years, $rate");
      return mortgagePayment(amount, rate, years);
    }
    return 0;
  }

  // end <class MortgageDetails>
}



// custom <mortgage_calculator>
// end <mortgage_calculator>

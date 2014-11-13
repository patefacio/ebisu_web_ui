library payment_schedule;
import 'dart:html' hide Timeline;
import 'dart:html';
import 'date_input.dart';
import 'package:logging/logging.dart';
import 'package:money/format.dart';
import 'package:polymer/polymer.dart';

// custom <additional imports>
// end <additional imports>


final _logger = new Logger("paymentSchedule");

@CustomTag("payment-schedule")
class PaymentSchedule extends PolymerElement {

  DateInput dateInput;
  TableElement scheduleTable;

  PaymentSchedule.created() : super.created() {
    _logger.fine('PaymentSchedule created sr => $shadowRoot');
    // custom <PaymentSchedule created>

    if(shadowRoot != null) {
      (dateInput = $["date"] as DateInput)..label = "yyyy-MM-dd";

      scheduleTable = ($['schedule_table'] as TableElement);
      scheduleTable
        ..caption = (scheduleTable.createCaption()..innerHtml = 'Payment Schedule')
        ..tHead =
        (scheduleTable.createTHead()..innerHtml =
            '<td>Date</td><td>Payment</td><td>Balance</td>')
        ..tFoot = (scheduleTable.createTFoot()..innerHtml = 'Table Footer');
    }

    // end <PaymentSchedule created>

  }

  @override
  void domReady() {
    super.domReady();
    _logger.fine('PaymentSchedule domReady with sr => $shadowRoot');
    // custom <PaymentSchedule domReady>
    // end <PaymentSchedule domReady>

  }

  @override
  void ready() {
    super.ready();
    _logger.fine('PaymentSchedule ready with sr => $shadowRoot');
    // custom <PaymentSchedule ready>
    // end <PaymentSchedule ready>

  }

  @override
  void attached() {
    // custom <PaymentSchedule pre-attached>
    // end <PaymentSchedule pre-attached>

    super.attached();
    _logger.fine('PaymentSchedule attached with sr => $shadowRoot');
    assert(shadowRoot != null);
    // custom <PaymentSchedule attached>
    // end <PaymentSchedule attached>

    _isAttached = true;
    _onAttachedHandlers.forEach((handler) => handler(this));
  }

  void onAttached(void onAttachedHandler(PaymentSchedule)) {
    if(_isAttached) {
      onAttachedHandler(this);
    } else {
      _onAttachedHandlers.add(onAttachedHandler);
    }
  }


  // custom <class PaymentSchedule>

  bool get applyAuthorStyles => true;

  // end <class PaymentSchedule>
  bool _isAttached = false;
  List _onAttachedHandlers = [];
}




// custom <payment_schedule>
// end <payment_schedule>

require 'spec_helper' 

describe "Create payment on a successful charge" do 
  let(:event_data) do 
    event_date = 
        { 
          id: ch_17ISRMBDRuCwc6R26RFsyUJd,
          object: "charge",
          amount: 999,
          amount_refunded: 0,
          application_fee: null,
          balance_transaction: "txn_17ISRMBDRuCwc6R2EMhey2Ib",
          captured: true,
          created: 1450222964,
          currency: "cad",
          customer: cus_7XXWpi5x0hJMHu,
          description: null,
          destination: null,
          dispute: null,
          failure_code: null,
          failure_message: null,
          fraud_details:
          {}, 
          invoice: in_17ISRMBDRuCwc6R2dj1GtKlY,
          livemode: false,
          metadata:
          {},
          paid: true
          receipt_email: null,
          receipt_number: null,
          refunded: false,
          refunds:
          {
            object: "list",
            data:
            [],
            has_more: false,
            total_count: 0,
            url: "/v1/charges/ch_17ISRMBDRuCwc6R26RFsyUJd/refunds",
          },
          shipping: null,
          source:
          {
            id: card_17ISRLBDRuCwc6R2CkH5REJZ,
            object: "card",
            address_city: null,
            address_country: null,
            address_line1: null,
            address_line1_check: null,
            address_line2: null,
            address_state: null,
            address_zip: null,
            address_zip_check: null,
            brand: "Visa",
            country: "US",
            customer: cus_7XXWpi5x0hJMHu,
            cvc_check: "pass",
            dynamic_last4: null,
            exp_month: 7,
            exp_year: 2016,
            fingerprint: "SAow76ubNBhomPEk",
            funding: "credit",
            last4: "4242",
            metadata:
            {},
            name: null,
            tokenization_method: null
          }
          statement_descriptor: null,
          status: "succeeded"
        }
    }

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end



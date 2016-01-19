require 'spec_helper' 

describe "Create payment on a successful charge" do 
    let(:event_data) do
      {
        "created"=> 1326853478,
        "livemode"=> false,
        "id"=> "evt_00000000000000",
        "type"=> "charge.succeeded",
        "object"=> "event",
        "request"=> nil,
        "pending_webhooks"=> 1,
        "api_version"=> "2015-10-16",
        "data" => {
          "object"=> {
            "id"=> "ch_17ISRMBDRuCwc6R26RFsyUJd",
            "object"=> "charge",
            "amount"=> 999,
            "amount_refunded"=> 0,
            "application_fee"=> nil,
            "balance_transaction"=> "txn_17ISRMBDRuCwc6R2EMhey2Ib",
            "captured"=> false,
            "created"=> 1450222964,
            "currency"=> "cad",
            "customer"=> 'cus_7XXWpi5x0hJMHu',
            "description"=> "With a valid charge",
            "destination"=> nil,
            "dispute"=> nil,
            "failure_code"=> "card_declined",
            "failure_message"=> "Your card was declined.",
            "fraud_details"=> {
            },
            "invoice"=> nil,
            "livemode"=> false,
            "metadata"=> {
            },
            "paid"=> true,
            "receipt_email"=> nil,
            "receipt_number"=> nil,
            "refunded"=> false,
            "refunds"=> {
              "object"=> "list",
              "data"=> [

              ],
              "has_more"=> false,
              "total_count"=> 0,
              "url"=> "/v1/charges/ch_17QeD2BDRuCwc6R2ly66Pyzw/refunds"
            },
            "shipping"=> nil,
            "source"=> {
              "id"=> "card_00000000000000",
              "object"=> "card",
              "address_city"=> nil,
              "address_country"=> nil,
              "address_line1"=> nil,
              "address_line1_check"=> nil,
              "address_line2"=> nil,
              "address_state"=> nil,
              "address_zip"=> nil,
              "address_zip_check"=> nil,
              "brand"=> "Visa",
              "country"=> "US",
              "customer"=> 'cus_7XXWpi5x0hJMHu',
              "cvc_check"=> "pass",
              "dynamic_last4"=> nil,
              "exp_month"=> 12,
              "exp_year"=> 2018,
              "funding"=> "credit",
              "last4"=> "0002",
              "metadata"=> {
              },
              "name"=> nil,
              "tokenization_method"=> nil
            },
            "statement_descriptor"=> nil,
            "status"=> "failed"
        }
      }
    } 
  end
   

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do 
    alice = Fabricate(:user, customer_token: 'cus_7XXWpi5x0hJMHu')
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do 
    alice = Fabricate(:user, customer_token: 'cus_7XXWpi5x0hJMHu')
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do 
    alice = Fabricate(:user, customer_token: 'cus_7XXWpi5x0hJMHu')
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_17ISRMBDRuCwc6R26RFsyUJd")
  end
end



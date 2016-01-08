module StripeWrapper 
  class Charge
    attr_reader :error_message, :response
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount], 
          currency: 'usd', 
          card: options[:card], 
          description: options[:description]
          )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message) #this is called named arguments, 
        #ruby 2.0 has made support for this, if not on ruby 2.0 
        #can simply pass the hash into this i.e options[:error_message]
      end
    end

    def successful? 
      response.present? 
    end
  end

  class Customer 
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          email: options[:user].email,
          plan: "basic"
        )
        new(response: response)
      rescue Stripe::CardError => e 
        new(error_message: e.message)
      end
    end

    def successful?
      response.present? 
    end

    def customer_token 
      response.id
    end
  end
end
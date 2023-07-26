module SubmissionHelper
    def formatted_transaction_fee(base_price, transaction_price)
        stripe_base_price = Stripe::Price.retrieve(base_price.stripe_key).unit_amount
        stripe_transaction_price = Stripe::Price.retrieve(transaction_price.stripe_key).unit_amount
        
        diff = stripe_transaction_price - stripe_base_price
        sprintf('%.2f', diff.to_f/100)
    end

end
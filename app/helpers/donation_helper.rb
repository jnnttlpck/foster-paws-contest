module DonationHelper
    def price_display(price)
        if price.unit_amount
            '$ ' + sprintf('%.0f',price.unit_amount/100)
        else
            'Other'
        end
    end
end
class DonationsController < ApplicationController
    def create
        session = Stripe::Checkout::Session.create({
            line_items: [{price: params[:amount], quantity: 1}],
            mode: 'payment',
            success_url: "http://localhost:3000/donations/success",
            cancel_url: "http://localhost:3000/donations/cancel"
        })
        redirect_to session.url, status: 303, allow_other_host: true
    end

    def success
    end

    def cancel
    end
end
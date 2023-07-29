class DonationsController < ApplicationController

    def create
        session = Stripe::Checkout::Session.create({
            line_items: [{price: params[:amount], quantity: 1}],
            mode: 'payment',
            success_url: success_donations_url,
            cancel_url: cancel_donations_url
        })
        redirect_to session.url, status: 303, allow_other_host: true
    end

    def success
    end

    def cancel
    end
end
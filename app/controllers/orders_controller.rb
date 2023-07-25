class OrdersController < ApplicationController
    invisible_captcha only: [:create], honeypot: :subtitle
    
    def new
        @order = Order.new
        @product = Product.find_by(name: 'Calendar')
    end

    def create
        @order = Order.new(order_params)
        @order.status = :open
        line_items = @order.line_items.map do |li|
            price = li.cover_transaction_fee? ? li.price.product.prices.find_by(transaction_fee: true) : li.price
            { price: price.stripe_key, quantity: li.quantity }
        end
        if @order.save!
            session = Stripe::Checkout::Session.create({
                line_items: line_items,
                mode: 'payment',
                success_url: "http://localhost:3000/orders/#{@order.id}/success?session_id={CHECKOUT_SESSION_ID}",
                cancel_url: "http://localhost:3000/orders/#{@order.id}/cancel"
            })
            redirect_to session.url, status: 303, allow_other_host: true
        else 
            render :new, status: :unprocessable_entity
        end
    end

    def success
        @order = Order.find(params[:order_id])
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @order.update(status: session.status)
    end

    def cancel
    end

    private

    def order_params
        params.require(:order).permit(:email, :name, :line_1, :line_2, :city, :state, :zip, line_items_attributes: [:id, :quantity, :price_id, :cover_transaction_fee])
    end

end
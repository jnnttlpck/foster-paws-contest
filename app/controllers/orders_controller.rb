class OrdersController < ApplicationController
    def new
        @order = Order.new
        @product = Product.find_by(name: 'Calendar')
    end

    def create
        @order = Order.create(order_params)
        @order.status = :open
        if @order.save!
            session = Stripe::Checkout::Session.create({
                line_items: [{
                    price: @order.product.stripe_price_key,
                    quantity: @order.quantity
                }],
                mode: 'payment',
                success_url: "http://localhost:3000/orders/#{@order.id}/success?session_id={CHECKOUT_SESSION_ID}",
                cancel_url: "http://localhost:3000/orders/#{@order.id}/cancel"
            })
            redirect_to session.url, status: 303, allow_other_host: true
        else 
            render :new, status: :unprocessible_entity
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
        params.require(:order).permit(:quantity, :product_id, :email)
    end

end
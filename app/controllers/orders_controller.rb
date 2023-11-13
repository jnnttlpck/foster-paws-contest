require 'csv'

class OrdersController < ApplicationController
    invisible_captcha only: [:create], honeypot: :subtitle
    before_action :authenticate_user!, only: [:new, :create]

    def index
        @orders = Order.where(status: :complete)
    end
    
    def new
        @order = Order.new
        @product = Product.find_by(name: 'Calendar')
    end

    def create
        @order = Order.new(order_params)
        @order.status = :open
        line_items = @order.line_items.map do |li|
            { price: li.price.stripe_key, quantity: li.quantity }
        end
        shipping_options = @order.ship? ? [{
            shipping_rate: Product.find_by(name: 'shipping').prices.first.stripe_key
        }] : []
        if @order.save
            session = Stripe::Checkout::Session.create({
                line_items: line_items,
                shipping_options: shipping_options,
                mode: 'payment',
                success_url: order_success_url(@order.id) + "?session_id={CHECKOUT_SESSION_ID}",
                cancel_url: order_cancel_url(@order.id),
                allow_promotion_codes: true
            })
            redirect_to session.url, status: 303, allow_other_host: true
        else 
            flash[:alert] = @order.errors.full_messages.join(' ')
            render :new
        end
    end

    def success
        @order = Order.find(params[:order_id])
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @order.update(status: session.status)
    end

    def cancel
    end

    def export
        @orders = Order.where(status: :complete).where.not(delivery_option: :ship)
        respond_to do |format|
            format.csv do
                response.headers['Content-Type'] = 'text/csv'
                response.headers['Content-Disposition'] = "attachment; filname=orders.csv"
            end
        end
    end

    private

    def order_params
        params.require(:order).permit(:user_id, :name, :line_1, :line_2, :city, :state, :zip, :delivery_option, line_items_attributes: [:id, :quantity, :price_id, :cover_transaction_fee])
    end

end
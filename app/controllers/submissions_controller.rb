class SubmissionsController < ApplicationController
    invisible_captcha only: [:create], honeypot: :subtitle
    before_action :authenticate_user!, only: [:new, :create, :pay]
    before_action :set_stripe_vars, only: [:new, :create, :pay]
    before_action lambda {
        resize_image_before_upload(submission_params[:file], 800, 800)
    }, only: [:create]

    def index
        @submissions = Submission.where(status: :complete, approved: true).reverse
    end

    def needs_approval
        @submissions = Submission.where(status: :complete, approved: nil)
    end

    def log_approvals
        params[:submission].each do |id, approved|
            Submission.find(id).update(approved: approved[:approved])
        end
        redirect_to submissions_path, notice: 'Submissions Approved'
    end

    def show
        @submission = Submission.find(params[:id])
    end

    def new
        @submission = Submission.new
        if Date.today > Date.new(2023,8,31)
            redirect_to closed_submissions_path
        end
    end

    def closed
    end

    def my_submissions
        if current_user 
            @submissions = current_user.submissions 
        else
            redirect_to new_user_session_path
        end
    end

    def create
        # TODO: set open to status default
        @submission = Submission.new(submission_params)
        @submission.status = :open
        line_items = []
        shipping_rate = []
        if (@order = @submission.order)
            @submission.order.status = :open
            @submission.order.user = current_user
            line_items << @order.line_items.map do |li|
                { price: li.price.stripe_key, quantity: li.quantity }
            end
            shipping_rate << {
                shipping_rate: Product.find_by(name: 'shipping').prices.first.stripe_key
            }
        end
        submission_price = @submission.cover_transaction_fee? ? @transaction_price : @base_price
        line_items << {
            price: submission_price.stripe_key,
            quantity: 1
        }
        if @submission.save
            session = Stripe::Checkout::Session.create({
                line_items: line_items.flatten,
                shipping_options: shipping_rate,
                mode: 'payment',
                success_url: submission_success_url(@submission.id) + "?session_id={CHECKOUT_SESSION_ID}",
                cancel_url: submission_cancel_url(@submission.id)    
            })
            redirect_to session.url, status: 303, allow_other_host: true
        else
            flash[:alert] = @submission.errors.full_messages.join(' ')
            render :new
        end
    end

    def pay
        @submission = Submission.find(params[:id])
        line_items = []
        shipping_rate = []
        if (@order = @submission.order)
            @submission.order.status = :open
            @submission.order.user = current_user
            line_items << @order.line_items.map do |li|
                { price: li.price.stripe_key, quantity: li.quantity }
            end
            shipping_rate << {
                shipping_rate: Product.find_by(name: 'shipping').prices.first.stripe_key
            }
        end
        submission_price = @submission.cover_transaction_fee? ? @transaction_price : @base_price
        line_items << {
            price: submission_price.stripe_key,
            quantity: 1
        }
        session = Stripe::Checkout::Session.create({
            line_items: line_items.flatten,
            shipping_options: shipping_rate,
            mode: 'payment',
            success_url: submission_success_url(@submission.id) + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: submission_cancel_url(@submission.id)    
        })
        redirect_to session.url, status: 303, allow_other_host: true
    end

    def success
        @submission = Submission.find(params[:submission_id])
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @submission.update(status: session.status)
        @submission.order.update(status: session.status) if @submission.order
    end

    def cancel
        @submission = Submission.find(params[:submission_id])
        @submission.destroy
    end

    def add_order
        @submission = Submission.new
        @order = Order.new
    end

    private

    def submission_params
        params.require(:submission).permit(:first_name, :last_name, :location, :pet_name, :got_cat, :about, :cover_transaction_fee, :file, :year, :cat_age, :user_id, :rules_and_conditions,
            order_attributes: [:id, :name, :line_1, :line_2, :city, :state, :zip, line_items_attributes: [:quantity, :price_id, :cover_transaction_fee]]
        )
    end

    def resize_image_before_upload(image_param, width, height)
        return unless image_param

        begin
          ImageProcessing::MiniMagick
            .source(image_param)
            .resize_to_fit(width, height)
            .call(destination: image_param.tempfile.path)
        rescue StandardError => e
        end
    end

    def set_stripe_vars
        submission_product = Product.find_by(name: 'submission')
        @base_price = submission_product.prices.find_by(transaction_fee: false)
        @transaction_price = submission_product.prices.find_by(transaction_fee: true)
    end
end
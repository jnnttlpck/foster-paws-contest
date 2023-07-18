class SubmissionsController < ApplicationController

    def show
        @submission = Submission.find(params[:id])
    end

    def new
        @submission = Submission.new
    end

    def create
        @submission = Submission.new(submission_params)
        @submission.status = :open

        if @submission.save!
            session = Stripe::Checkout::Session.create({
                line_items: [{
                    price: Product.find_by(name: 'Submission').stripe_price_key,
                    quantity: 1,
    
                }],
                mode: 'payment',
                success_url: "http://localhost:3000/submissions/#{@submission.id}/success?session_id={CHECKOUT_SESSION_ID}",
                cancel_url: "http://localhost:3000/submissions/#{@submission.id}/cancel"
    
            })
            redirect_to session.url, allow_other_host: true
            # redirect_to @submission, notice: 'Thank you!'
        else
            render :new, alert: @submission.errors.messages
        end
    end

    def success
        @submission = Submission.find(params[:submission_id])
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @submission.update(status: session.status)
    end

    def cancel
        @submission = Submission.find(params[:submission_id])
    end

    private

    def submission_params
        params.require(:submission).permit(:first_name, :last_name, :email, :location, :pet_name, :file)
    end
end
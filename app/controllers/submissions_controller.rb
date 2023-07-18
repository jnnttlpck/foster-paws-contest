class SubmissionsController < ApplicationController

    def show
        @submission = Submission.find(params[:id])
    end

    def new
        @submission = Submission.new
    end

    def create
        @submission = Submission.new(submission_params)
        # @submission.file.attach(params[:file])

        if @submission.save!
            session = Stripe::Checkout::Session.create({
                line_items: [{
                    price: 'price_1NV19wCwjzVCdpYN6O6hk8Hn',
                    quantity: 1,
    
                }],
                mode: 'payment',
                success_url: "http://localhost:3000/submissions/#{@submission.id}",
                cancel_url: 'http://localhost:3000/index.html'
    
            })
            redirect_to session.url, allow_other_host: true
            # redirect_to @submission, notice: 'Thank you!'
        else
            render :new, alert: @submission.errors.messages
        end
    end

    private

    def submission_params
        params.require(:submission).permit(:first_name, :last_name, :email, :location, :pet_name, :file)
    end
end
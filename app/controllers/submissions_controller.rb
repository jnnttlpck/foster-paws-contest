class SubmissionsController < ApplicationController

    def show
        @submission = Submission.find(params[:id])
    end

    def new
        @submission = Submission.new
    end

    def create
        debugger
        @submission = Submission.new(submission_params)
        debugger
        if @submission.save!
            redirect_to @submission, notice: 'Thank you!'
        else
            render :new, alert: @submission.errors.messages
        end
    end

    private

    def submission_params
        params.require(:submission).permit(:first_name, :last_name, :email, :location, :pet_name)
    end
end
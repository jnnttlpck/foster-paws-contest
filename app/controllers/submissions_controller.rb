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
            redirect_to @submission, notice: 'Thank you!'
        else
            render :new, alert: @submission.errors.messages
        end
    end

    private

    def submission_params
        params.require(:submission).permit(:first_name, :last_name, :email, :location, :pet_name, :file)
    end
end
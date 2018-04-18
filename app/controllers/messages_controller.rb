class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new message_params
    if @message.valid?
      MessageMailer.contact(@message).deliver_now
      redirect_to signed_up_path, notice: "We have received your message and will be in touch soon!"
    else       
      render :new, notice: "There was an error sending your message. Please try again."
    end
  end

  def complete
  end

  private
    def message_params
      params.require(:message).permit(:name, :email, :phone, :body)
    end

end


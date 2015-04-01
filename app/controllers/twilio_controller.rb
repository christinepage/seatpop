require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  def send_sms
    @client = Twilio::REST::Client.new(
      TwilioConfig.config_param('account_sid'),
      TwilioConfig.config_param('auth_token'))

    begin
      message = @client.account.messages.create(
       :body => params[:sms_body],
       :to => '+1' + params[:phone],
       :from => TwilioConfig.config_param('caller'))

      # Twilio throws an exception if the phone number is unverified
      # or otherwise bogus looking, so recover and save the errors.
    rescue Twilio::REST::RequestError => e
      logger.debug e.message
      flash[:notice] = "The call to #{params[:phone]} did not go through."
      (flash[:errors] ||= []) << e.message
    end
    redirect_to :controller => 'parties', :action => 'index'
  end

  def receive_sms
    logger.debug "Received a message"
    @city = params[:FromCity].capitalize
    @state = params[:FromState]
    render 'process_sms.xml.erb', :content_type => 'text/xml'
  end

end

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
    matchdata = /[0-9]*/.match(params[:body])
    party_key = matchdata[0]
    logger.debug "Received a message from tel: #{params[:from]} with body: #{params[:body]}"
    logger.debug "Assuming party_key: #{party_key}"
    render 'process_sms.xml.erb', :content_type => 'text/xml'
  end

end

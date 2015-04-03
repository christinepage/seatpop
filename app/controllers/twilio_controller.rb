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
    redirect_to :controller => 'restaurants', :action => 'show', :id => params[:restaurant_id]
  end

  def receive_sms 
    body = params[:Body] || ""
    @party_key = body.to_i

    @party = Party.find(@party_key)
    if @party.nil?
      render 'process_bad_party_id.xml.erb', :content_type => 'text/xml'
    else
      @restaurant = Restaurant.find(@party.restaurant_id)
      ahead_list = Party.where(restaurant:@party.restaurant, party_status_id: 1).where(["created_at <= ?", @party.created_at]).count
      @waiting_list_pos = ahead_list.count
      logger.debug "Received a message from tel: #{params[:From]} with body: #{params[:Body]}"
      logger.debug "Assuming party_key: #{@party_key}"
      render 'process_sms.xml.erb', :content_type => 'text/xml'
    end
  end

end

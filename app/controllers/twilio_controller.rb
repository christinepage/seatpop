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
      flash[:notice] = "The sms to #{params[:phone]} did not go through."
      (flash[:errors] ||= []) << e.message
    end
    redirect_to :controller => 'restaurants', :action => 'show', :id => params[:restaurant_id]
  end

  # receive_sms:
  # valid sms commands are:
  #   [token]               (waiting list status)
  #   [token] cancel        (remove from list)
  #   [token] drop          (drop down 1 party)
  #   [token] size [number] (change party size)

  def receive_sms 
    sender_tel = params[:From] || ""
    body = params[:Body] || ""
    body_tokens = body.split(" ")

    logger.debug "Received a message from tel: #{sender_tel} with body: #{body}"

    if body_tokens.size == 0
      render 'process_bad_party_id.xml.erb', :content_type => 'text/xml' and return
    end

    @party_token = body_tokens[0].to_i
    @party = Party.find_by(token: @party_token)
    logger.debug "Assuming party_token: #{@party_token}"

    if @party.nil?
      logger.debug "got an SMS request with a bad party token"
      render 'process_bad_party_id.xml.erb', :content_type => 'text/xml' and return
    end

    if body_tokens.size == 1
      logger.debug "got an SMS request for party status"
      @waiting_list_pos = @party.waiting_list_position
      render 'process_sms.xml.erb', :content_type => 'text/xml' and return
    end

    twilio_format_phone = "+1" + @party.phone.gsub!(/[^0-9]/, '')
    # for editing functions, cancel, drop, size, must be from the party phone number in the db
    if (body_tokens.size > 1) && (["cancel", "drop", "size"].include?(body_tokens[1])) && (sender_tel != twilio_format_phone)
      logger.debug "got an SMS request for to edit a party from unauthorized number (#{sender_tel} but need #{twilio_format_phone})"
      render 'process_unauthorized_sms.xml.erb', :content_type => 'text/xml' and return
    end

    if (body_tokens.size == 2) && (body_tokens[1] == "cancel")
      logger.debug "got an SMS request to cancel party"
      @party.update_attributes(party_status: PartyStatus.find_by(name: "exited"))
      render 'process_cancel_sms.xml.erb', :content_type => 'text/xml' and return
    end

    ## wait on implementing this
    if (body_tokens.size == 2) && (body_tokens[1] == "drop")
      logger.debug "got an SMS request to drop down party"
      render 'process_drop_sms.xml.erb', :content_type => 'text/xml' and return
    end

    if (body_tokens.size == 3) && (body_tokens[1] == "size")
      logger.debug "got an SMS request to change party size"
      @old_size = @party.size
      @party.update_attributes(size: body_tokens[2].to_i)   
      render 'process_change_size_sms.xml.erb', :content_type => 'text/xml' and return
    end

    # an invalid command
    logger.debug "got an SMS request that was invalid"
    render 'process_bad_party_id.xml.erb', :content_type => 'text/xml' and return
  end

end

require 'securerandom'

class ApiController < ApplicationController  
  http_basic_authenticate_with name:ENV["API_AUTH_NAME"], password:ENV["API_AUTH_PASSWORD"], :only => [:signup,  :get_token]  
  before_filter :check_for_valid_authtoken, :except => [:signup, :signin, :get_token]
  skip_before_filter  :verify_authenticity_token
  
  def signin #replace with SessionsController::create?
    if request.post?
      if params && params[:email] && params[:password] 
        user = User.find_by(email: params[:email].downcase)
        if user && user.authenticate(params[:password])
          if user.activated?
            log_in user
            params[:remember_me] == '1' ? remember(user) : forget(user)
            if !user.api_authtoken || (user.api_authtoken && user.authtoken_expiry < Time.now)
              auth_token = rand_string(20)
              auth_expiry = Time.now + (24*60*60)
              user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)   
              user_hash = user.attributes
              user_hash[:restaurant] = user.restaurants.first.name 
            end 
            p user_hash.to_json
            render :json => user.to_json, :status => 200
          else
            message  = "Account not activated. "
            message += "Check your email for the activation link."
            flash[:warning] = message
            redirect_to root_url
          end
        else
          e = Error.new(:status => 400, :message => "Invalid email/password combination")
          render :json => e.to_json, :status => 400
        end
      else
        e = Error.new(:status => 400, :message => "required parameters are missing")
        render :json => e.to_json, :status => 400
      end
    end
  end
  
  def reset_password #replace with PasswordResetsController?
    if request.post?
      if params && params[:old_password] && params[:new_password]         
        if @user         
          if @user.authtoken_expiry > Time.now
            authenticate_user = User.authenticate(@user.email, params[:old_password])
                        
            if authenticate_user && !authenticate_user.nil?             
              auth_token = rand_string(20)
              auth_expiry = Time.now + (24*60*60)
            
              begin
                new_password = params[:new_password] #AESCrypt.decrypt(params[:new_password], ENV["API_AUTH_PASSWORD"])  
              rescue Exception => e
                new_password = nil
                puts "error - #{e.message}"
              end
              
              new_password_salt = BCrypt::Engine.generate_salt
              new_password_digest = BCrypt::Engine.hash_secret(new_password, new_password_salt)
                              
              @user.update_attributes(:password => new_password, :api_authtoken => auth_token, :authtoken_expiry => auth_expiry, :password_salt => new_password_salt, :password_hash => new_password_digest)
              render :json => @user.to_json, :status => 200           
            else
              e = Error.new(:status => 401, :message => "Wrong Password")
              render :json => e.to_json, :status => 401
            end
          else
            e = Error.new(:status => 401, :message => "Authtoken is invalid or has expired. Kindly refresh the token and try again!")
            render :json => e.to_json, :status => 401
          end
        else
          e = Error.new(:status => 400, :message => "No user record found for this email ID")
          render :json => e.to_json, :status => 400
        end
      else
        e = Error.new(:status => 400, :message => "required parameters are missing")
        render :json => e.to_json, :status => 400
      end
    end
  end
  
  def get_token
    if params && params[:email]    
      user = User.where(:email => params[:email]).first
    
      if user 
        if !user.api_authtoken || (user.api_authtoken && user.authtoken_expiry < Time.now)          
          auth_token = rand_string(20)
          auth_expiry = Time.now + (24*60*60)
          
          user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)                              
        end        
        
        render :json => user.to_json(:only => [:api_authtoken, :authtoken_expiry])                
      else
        e = Error.new(:status => 400, :message => "No user record found for this email ID")
        render :json => e.to_json, :status => 400
      end
      
    else
      e = Error.new(:status => 400, :message => "required parameters are missing")
      render :json => e.to_json, :status => 400
    end
  end

  def clear_token
    if @user.api_authtoken && @user.authtoken_expiry > Time.now
      @user.update_attributes(:api_authtoken => nil, :authtoken_expiry => nil)
          
      m = Message.new(:status => 200, :message => "Token cleared")          
      render :json => m.to_json, :status => 200  
    else
      e = Error.new(:status => 401, :message => "You don't have permission to do this task")
      render :json => e.to_json, :status => 401
    end 
  end
  
  def add_party #direct to PartiesController::create -> Required Params:: restaurant_id, :party, :name, :size, :phone
    if request.post?
      if params[:name] && params[:size]    
        if @user #&& @user.authtoken_expiry > Time.now
          @restaurant = @user.restaurants.first
          @party = @restaurant.parties.build(name: params[:name],size: params[:size], phone: params[:phone])
          if @party.save
            flash[:success] = "Party created with token #{@party.token} !"
            redirect_to :controller => "twilio",
              :action => "send_sms",
              :restaurant_id => @party.restaurant_id,
              :phone =>@party.phone,
              :sms_body => "#{@party.name}, Your party token at #{@party.restaurant.name} is: #{@party.token}. Text back #{@party.token} for status."
              #get_waitlist
          else
            e = Error.new(:status => 401, :message => "Party could NOT be created!")
            render :json => e.to_json, :status => 401
          end
        else
          e = Error.new(:status => 401, :message => "Authtoken has expired")
          render :json => e.to_json, :status => 401
        end
      else
        e = Error.new(:status => 400, :message => "required parameters are missing")
        render :json => e.to_json, :status => 400
      end
    end
  
  end

  def get_waitlist
    if @user && @user.authtoken_expiry > Time.now
      waitlist = @user.restaurants.first.waitlist
      render :json => waitlist.to_json, :status => 200
    else
      e = Error.new(:status => 401, :message => "Authtoken has expired. Please get a new token and try again!")
      render :json => e.to_json, :status => 401
    end
  end
  
  def get_restaurant
    if @user && @user.authtoken_expiry > Time.now
      restaurant = @user.restaurants.first.name
      render :json => restaurant.to_json, :status => 200
    else
      e = Error.new(:status => 401, :message => "Authtoken has expired. Please get a new token and try again!")
      render :json => e.to_json, :status => 401
    end
  end
  

  private 
  
  def check_for_valid_authtoken
    authenticate_or_request_with_http_token do |token, options|     
      @user = User.where(:api_authtoken => token).first      
    end
  end
  
  def rand_string(len)
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    string  =  (0..len).map{ o[rand(o.length)]  }.join

    return string
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_hash, :password_salt, :verification_code, 
    :email_verification, :api_authtoken, :authtoken_expiry)
  end
  
  def photo_params
    params.require(:photo).permit(:name, :title, :user_id, :random_id, :image_url)
  end
    
end
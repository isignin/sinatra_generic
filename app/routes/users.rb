module MyApp
  module Routes
    class Users < Base
          
      get '/users' do
        @users = User.all
        erb :"users/index"
      end
      
      get "/users/new" do
        user = User.new
        erb :"users/new"
      end
      
      get "/users/:id" do
        @user = User[params[:id]]
        erb :"users/show"
      end
      
      get "/users/:id/edit" do
        @user = User[params[:id]]
        erb :"users/edit"
      end
      
      post '/users' do
        @user = User.new params[:user]
        if @user.save
         flash.now[:notice]="New User Record posted"
         erb :"users/show"
        else
         flash.now[:alert]= "Error saving record"
        end
      end
        
      put '/users/:id' do
         @user = User[params[:id]]
         if !@user.nil? 
           if @user.update(params[:user])
             if @user.errors.empty?
               flash.now[:notice]= "Record updated successfully"
               erb :"/users/show"
             else
               flash.now[:alert]="Error encountered updating record. Please notify your administrator."
             end
           else
            flash.now[:notice]= "No change to update"
            erb :"/users/show"    
           end
         else
           flash.now[:alert] = "Error: User not found"
         end
      end
      
        
      delete '/users/:id' do
        user = User[params[:id]]
        if !user.nil? 
          if user.delete
            flash.now[:notice]="Record delete successfully"
          else
            status 500
            json user.errors.full_message
          end
        else
          flash.now[:alert]="Record Not found"
        end  
      end  
      
      get '/login' do
        erb :"users/login"
      end  
      
      post '/login' do
        @user = User[:username => params[:username]]
         if !@user.nil?
           if @user.verified == 0
            flash.now[:alert] = "Your Email address has not been verified"
            erb :'users/login'
           else
             if @user.authenticate(params[:password]).nil?
                flash.now[:notice] = "Incorrect password" 
                erb :'users/login'    
             else
                flash.now[:notice] = "User is verified. You are ok, #{@user.username}"
              end 
           end  
         else
          flash.now[:notice] = "Sorry. I don't know you #{params[:username]}"
          erb :'users/login'
         end
      end
      
      get '/sign_up' do
        @user = User.new
        erb :"users/signup"
      end
      
      post '/sign_up' do
        require 'securerandom'
        @user = User.new params[:user]  
        if @user.password == @user.password_confirmation           
          if User[:username => @user.username]
            flash.now[:alert]="Username is already taken"
            erb :"users/signup"
          else  
            @user.verified = false
            @user.token = SecureRandom.urlsafe_base64.gsub(/\W+/, '')
            if @user.save
              #Send email via Mandrill
              Pony.mail :to => @user.email,
                        :from => 'admin@example.com',
                        :subject => 'Email address verification',
                        :html_body => erb(:"users/verification_mail"),
                        #:via => :smtp,
                        :via_options => {
                            :address              => 'smtp.mandrillapp.com',
                            :port                 => '587',
                            :user_name            => ENV['SMTP_USER'],
                            :password             => ENV['MANDRILL_APIKEY'],
                            :enable_starttls_auto => false
                          }
                        
              flash.now[:notice]="Verification Email sent"
            else
              flash.now[:alert]="Error saving record"
              erb :"users/signup"
            end 
          end
        else
          flash.now[:alert]="Your passwords do not match"
          erb :"users/signup"
        end         
      end
      
      get '/verify/:token' do
        @user = User[:token => params[:token]]
        if !@user.nil?
          if @user.update(:token => nil, :verified => true)
            erb :"users/verified"
          else
             @user.errors.full_message
          end
        else
          flash.now[:alert] = "Token invalid. Please contact your administrator"
        end
      end
      
      get '/reset_password' do
        erb :"users/password_reset_request"
      end
      
      post '/reset_password' do
        @user = User[:username => params[:username]]
        if !@user.nil?
          @user.update(:token => SecureRandom.urlsafe_base64.gsub(/\W+/, ''))
          #Send reset email via Mandrill
          Pony.mail :to => @user.email,
                    :from => 'admin@example.com',
                    :subject => 'Password reset',
                    :html_body => erb(:"users/password_reset_mail"),
                    #:via => :smtp,
                    :via_options => {
                        :address              => 'smtp.mandrillapp.com',
                        :port                 => '587',
                        :user_name            => ENV['SMTP_USER'],
                        :password             => ENV['MANDRILL_APIKEY'],
                        :enable_starttls_auto => false
                      }
         flash.now[:notice]= "Password reset email sent"
        else
          flash.now[:alert]= "Sorry. I do not know you...."
           erb :"users/password_reset_request"
        end    
      end
      
      get '/reset_password/:token' do
        @user = User[:token => params[:token]]
        if !@user.nil?
          @user.update(:token => nil)
          erb :"users/password_reset_form"
        else
          flash.now[:alert]= "Token invalid. Please contact your administrator"
        end
      end
      
      post '/reset_pass' do
        @user = User[params[:id]]
        if params[:password] == params[:password_confirmation]
         if @user.nil?
           flash.now[:alert] = "Do not know you..."
         else
           if !@user.update(:password => params[:password], :password_confirmation => params[:password_confirmation]).nil?
             flash.now[:notice]="Password has been reset"
           else
             flash.now[:alert]="Error encountered resetting your password. Please contact your administrator"
           end      
         end
        else
          flash.now[:alert]="New Password does not match your confirmation password"
          erb :"users/password_reset_form"
        end 
      end
          
    end
  end
end
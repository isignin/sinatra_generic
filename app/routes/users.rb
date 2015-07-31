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
         if !@user.nil? && @user.update(params[:user])
           flash.now[:notice]= "Record updated successfully"
           erb :"/users/show"
         else
           flash.now[:alert]= "Error updating record"
         end 
      end
      
        
      delete '/users/:id' do
        user = User[params[:id]]
        if !user.nil? 
          if user.delete
            "Record delete successfully"
          else
            status 500
            json user.errors.full_message
          end
        else
          "Record Not found"
        end  
      end  
      
      get '/login' do
        erb :"users/login"
      end  
      
      post '/login' do

        @user = User[:username => params[:username]]
         if !@user.nil?
           if @user.authenticate(params[:password]).nil?
              flash.now[:notice] = "Incorrect password" 
              redirect '/login'    
            else 
              if !@user.verified
               flash.now[:notice] = "User is not verified"
               redirect '/login'
              else
                flash.now[:notice] = "User is verified. You are ok, #{@user.username}"
                redirect "/"
              end 
            end  
         else
          flash.now[:notice] = "I don't know you #{params[:username]}"
          redirect '/login'
         end
      end
      
      post '/sign_up' do
        require 'securerandom'
        
        @user = User.new params[:user]
        @user.verified = false
        @user.token = SecureRandom.urlsafe_base64.gsub(/\W+/, '')
        if @user.save
          #Send email
          Pony.mail :to => @user.email,
                    :from => 'admin@example.com',
                    :subject => 'Email address verification',
                    :body => erb(:"users/verification_mail")
          flash.now[:notice]="Verification Email sent"
        else
          flash.now[:alert]= "Error saving record"
          user.errors.full_message
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
      
      post '/reset_password' do
        @user = User[:username => params[:username]]
        if !@user.nil?
          @user.update(:token => SecureRandom.urlsafe_base64.gsub(/\W+/, ''))
          #Send reset email
          Pony.mail :to => @user.email,
                    :from => 'admin@example.com',
                    :subject => 'Password reset',
                    :body => erb(:"users/password_reset_mail")
         flash.now[:notice]= "Password reset email sent"
        else
          flash.now[:alert] = "I do not know you...."
        end    
      end
      
      get '/reset_password/:long_token' do
        @user = User[:token => params[:token]]
        if !@user.nil?
          @user.update(:token => nil)
          erb :"users/password_reset_form"
        else
          flash.now[:alert]= "Token invalid. Please contact your administrator"
        end
      end
      
      post 'reset_now' do
        if params[:password] == params[:pass_confirm]
         @user = User[params[:id]]
         if @user.nil?
           flash.now[:alert]= "Do not know you..."
         else
           if @user.update(:password => params[:password])
             flash.now[:notice]="Password has been reset"
           else
             flash.now[:alert]= "Error encountered resetting your password. Please contact your administrator"
           end      
         end
        else
          flash.now[:alert]= "New Password does not match your confirm password"
        end 
      end
          
    end
  end
end
module MyApp
  module Helpers
    def fullname(user)
      user.first_name+" "+user.last_name
    end
    
    def yes_no(col)
      col == 1 ? "Yes" : "No"
    end 
    
  end
end  
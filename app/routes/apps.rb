module MyApp
  module Routes
    class Apps < Base
      get '/' do
        erb :"home"
      end
    end
  end
end
      
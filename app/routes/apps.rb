module Cms
  module Routes
    class Apps < Base
      configure do
        enable :partial_underscores
        set :partial_template_engine, :erb
      end
      get '/' do
        erb :"home"
      end
    end
  end
end
      
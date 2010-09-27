require "base64"

class Url < ActiveRecord::Base
    
  def create_hash 
    self.hash = Base64.encode64(self.id.to_s)
    self.save
  end
  
end

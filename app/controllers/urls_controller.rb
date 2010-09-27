class UrlsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :validate_signature 
  
  def index
    head :moved_permanently, :location => ROOT_URL
  end
  
  def create
    url = Url.find_or_create_by_target(params['url']);
    url.create_hash

    @short_url = "http://#{request.host_with_port}/#{url.hash}" 
    
    respond_to do |format|
       format.html
       format.json
    end
  end
  
  private 
  
  def validate_signature
    expected_signature = Digest::SHA1.hexdigest(SECRET+params['url'])
    head :unauthorized unless expected_signature == params['signature']
  end
end

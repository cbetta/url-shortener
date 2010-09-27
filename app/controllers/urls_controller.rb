require "base64"

class UrlsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :validate_signature, :only => :create
  
  def index
    head :moved_permanently, :location => ROOT_URL
  end
  
  def create
    url = Url.find_or_create_by_target(params['url']);
    hash = Base64.encode64(url.id.to_s).strip
    
    @short_url = "http://#{request.host_with_port}/#{hash}" 
    
    respond_to do |format|
       format.html
       format.json
    end
  end
  
  def view 
    id = Base64.decode64(params[:id].strip).to_i
    url = Url.where(:id => id).first
    if url.blank?
      render :status => 404
    else 
      head :moved_permanently, :location => url.target
    end
  end
  
  private 
  
  def validate_signature
    expected_signature = Digest::SHA1.hexdigest(SECRET+params['url'])
    head :unauthorized unless expected_signature == params['signature']
  end
end

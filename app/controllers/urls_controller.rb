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
    
    Rails.cache.write("short_url::#{hash}", params['url'])
    
    @short_url = "http://#{request.host_with_port}/#{hash}" 
    
    respond_to do |format|
       format.html
       format.json
    end
  end
  
  def view 
    # try and get the url from cache
    short_url = params[:id].strip
    long_url = Rails.cache.read("short_url::#{short_url}")
    if long_url.nil?
      id = Base64.decode64().to_i
      url = Url.where(:id => id).first
      if url.blank?
        render :status => 404
      else 
        Rails.cache.write("short_url::#{short_url}", url.target)
        head :moved_permanently, :location => url.target
      end
    else
      head :moved_permanently, :location => long_url
    end
  end
  
  private 
  
  def validate_signature
    expected_signature = Digest::SHA1.hexdigest(SECRET+params['url'])
    head :unauthorized unless expected_signature == params['signature']
  end
end

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
    #if not found, load and cache it
    if long_url.nil?
      #decode the short url to an int
      id = Base64.decode64(short_url).to_i
      #find the url object
      url = Url.where(:id => id).first
      #if url not found, 404
      if url.blank?
        #before 404, let's cache this negative result
        Rails.cache.write("short_url::#{short_url}", false)
        render :status => 404
      #else redirect to the long url
      else 
        #make sure to cache 
        Rails.cache.write("short_url::#{short_url}", url.target)
        head :moved_permanently, :location => url.target
      end
    #else just redirect to the long url
    else
      #check if the long url is not false
      if long_url == false
        #if so 404 
        render :status => 404
      else
        head :moved_permanently, :location => long_url
      end
    end
  end
  
  private 
  
  def validate_signature
    expected_signature = Digest::SHA1.hexdigest(SECRET+params['url'])
    head :unauthorized unless expected_signature == params['signature']
  end
end

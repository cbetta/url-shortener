class RedirectController < ApplicationController
  def index
    head :moved_permanently, :location => ROOT_URL
  end
end

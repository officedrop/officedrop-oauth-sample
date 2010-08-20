
class AssetsController < ApplicationController

  before_filter :login_required

  def index
    redirect_to( self.access_token.get( params[:path] )['Location'] )
  end

end
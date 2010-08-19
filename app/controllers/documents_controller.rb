
class DocumentsController < ApplicationController

  before_filter :login_required

  def index
    @documents = get( '/documents' )
    puts @documents.inspect
  end

end
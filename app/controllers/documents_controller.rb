
class DocumentsController < ApplicationController

  before_filter :login_required
  before_filter :load_page, :only => :index

  def index
    @documents = get( '/documents', :page => @page, :per_page => @per_page, :q => params[:q] )
  end

  def show
    @document = get( "/documents/#{params[:id]}" )
  end

  def create
    body, headers = http_multipart_data( :uploaded_data => params[:uploaded_data] )
    @batch = post( '/documents', body, headers )
    redirect_to documents_path
  end

  def pending
    @batches = get( '/batches', :status => 'started' )
  end

  protected

  def load_page
    @page     = params[:page] || 1
    @per_page = params[:per_page] || 10
  end

end
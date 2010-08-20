# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def officedrop_image_tag( path, options = {} )
    image_tag( assets_path( :path => path ), options )
  end

  def page_image_tag( document_id, page_number, format = :display )
    officedrop_image_tag(
      "#{OauthApplication.officedrop.site}/ze/api/documents/#{document_id}/pages/#{page_number}/#{format}",
      :class => "document_page"
    )
  end

  def pagination( collection )
    current_page = collection['pagination']['current_page']
    links = []
    if current_page > 1
      links << link_to_page('Previous Page', current_page - 1)
    end
    if current_page < collection['pagination']['total_pages']
      links << link_to_page('Next Page', current_page + 1)
    end
    links.join(' | ')
  end

  def link_to_page( text, page )
    link_to(text, documents_url( :page => page, :per_page => @per_page, :q => params[:q] ))
  end

end

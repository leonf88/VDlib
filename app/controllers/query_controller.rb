class QueryController < ApplicationController
  layout "basic"
  require 'thinking_sphinx'

  @@per_page=28

  # Get resources information according to the Region
  def region
    begin
      r=GRegion.find(params[:id])
      @videos=r.v_metadatas.paginate(:page => params[:page], :per_page => @@per_page)
      @query_info=r.name_chs

      respond_to do |format|
        format.html { render 'query/show' }
      end
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end

  # Get resources information according to the Provider
  def provider
    begin
      p=VProvider.find(params[:id])
      @videos=p.v_metadatas.paginate(:page => params[:page], :per_page => @@per_page)
      @query_info=p.detail

      respond_to do |format|
        format.html { render 'query/show' }
      end
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end

  # Get resources information according to the Key Word Tags
  def tag
    begin
      t=GTag.find(params[:id])
      @videos=t.v_metadatas.paginate(:page => params[:page], :per_page => @@per_page)
      @query_info=t.tag

      respond_to do |format|
        format.html { render 'query/show' }
      end
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end

  # Get the resources according to the key words in Region, Provider, Description, etc.
  def search
    begin
      words= params[:search][:qw].strip
      @query_info=words

      # search in the descriptions
      @videos=VMetadata.search(words, :page => params[:page], :per_page => @@per_page,
                               :match_mode => :any, :rank_mode => :proximity_bm25)

      respond_to do |format|
        format.html { render 'query/show' }
      end
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end

end

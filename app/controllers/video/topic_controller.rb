class Video::TopicController < ApplicationController
  layout "basic"

  @@per_page=28

  # Get all of the main categories
  def index
    @topics=GTopic.all
  end

  # Display the summary information about the topic and list several videos
  def show
    begin
      @topic_item=GTopic.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end

  # Display one topic and list all the videos page by page
  def detail
    begin
      @gsubtopic=GSubtopic.find(params[:id])
      @videos=@gsubtopic.v_metadatas.paginate(:page => params[:page], :per_page => @@per_page)
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end
end

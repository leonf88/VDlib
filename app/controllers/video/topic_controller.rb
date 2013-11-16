class Video::TopicController < ApplicationController
  layout "basic"

  # Get all of the main categories
  def index
    @topics=GTopic.all
  end

  # Display the summary information about the topic and list several videos
  def show
    @topic_item=GTopic.find(params[:id])
  end

  # Display one topic and list all the videos page by page
  def detail
    # TODO
    per_page=(params[:per_page] == nil) ? 20 : params[:per_page]
    @gtag=GTag.find(params[:id])
    @videos=@gtag.v_metadatas.paginate(:page => params[:page], :per_page => per_page)
  end

  def new

  end


end

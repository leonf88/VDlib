# encoding: utf-8
class Video::MediaController < ApplicationController
  layout "basic"

  # Get one video detail information, which used in the play view page.
  def show
    begin
      @video_item=VMetadata.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{Rails.root}/public/404.html",
             :status => "404 Not Found")
    end
  end
end

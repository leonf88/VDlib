# encoding: utf-8
class Video::MediaController < ApplicationController
  layout "basic"

  # Get one video detail information, which used in the play view page.
  def show
    @video_item=VMetadata.find(params[:id])
  end

  def new
    @video_item=VMetadata.new
  end

  def create
    @video_item=VMetadata.new(params[:video_item])
    @video_item.save
  end

  def edit
    @video_item=VMetadata.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
  end

  def delete
    @event = Event.find(params[:id])
    @event.destroy
  end
end

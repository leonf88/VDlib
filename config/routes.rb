VDlib::Application.routes.draw do

  root :to => "video/topic#index"
  match "query/search" => "query#search"

  namespace :video do
    match "region/:id" => "query#region", :as => :region
    match "provider/:id" => "query#provider", :as => :provider
    match "tag/:id" => "query#tag", :as => :tag
    get "topic/:id" => "topic#show", :as => :topic
    get "topic/:id/detail" => "topic#detail", :as => :topic_detail
    get "media/:id" => "media#show", :as => :media
  end
end

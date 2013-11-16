class QueryController < ApplicationController

  # Query the documents/videos according to the key words
  def search
    # TODO
    params[:page]=1 if (params[:page] == nil || Integer(params[:page]) < 0)
    @page_info={}
    if (params[:qw] !=nil && params[:qw].strip !="")
      key_word= params[:qw]
    elsif (params[:search][:qw] !=nil && params[:search][:qw].strip !="")
      key_word= params[:search][:qw]
    else
      flash[:notice]= "query condition can't be empty!"
    end
    case params[:qt]
      when 'kw'
        # search in the keywords
        videos_info=VMetadata.search(:conditions => {:keywords => key_word}, :page => params[:page],
                                     :per_page => $default_perpage_size, :match_mode => :any, :rank_mode => :proximity_bm25)
      when 'pl'
        # search in the places
        videos_info=VMetadata.search(:conditions => {:place => key_word}, :page => params[:page],
                                     :per_page => $default_perpage_size, :match_mode => :any, :rank_mode => :proximity_bm25)
      when 'des'
        # search in the descriptions
        videos_info=VMetadata.search(:conditions => {:description => key_word}, :page => params[:page],
                                     :per_page => $default_perpage_size, :match_mode => :any, :rank_mode => :proximity_bm25)
      else
        # search in all the information
        videos_info=VMetadata.search(key_word, :page => params[:page], :per_page => $default_perpage_size, :match_mode => :any, :rank_mode => :proximity_bm25)
    end
    @page_info[:cls_title]="查询词："+ key_word
    @page_info[:base_path]=$video_path_prefix +File::SEPARATOR
    @page_info[:videos_info]=videos_info
    respond_to do |format|
      format.html { render 'video/media/list' }
      format.json {
        v_info=[]
        videos_info.each do |v|
          video_item={}
          video_item[:video_id]=v.id.to_s
          video_item[:title_chs]= v.title_chs
          video_item[:title_eng]=v.title_eng
          video_item[:description]=truncate(v.description, :length => 50)
          video_item[:img_path]=v.img_path

          v_info<<video_item
        end
        render :json => {:videos_info => v_info}
      }
    end
  end

end

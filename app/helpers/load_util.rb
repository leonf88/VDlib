class LoadUtil

  private

  def getTempFile(sourceFile)
    tmp_path= @@upload_path
    tmp_file_url=tmp_path+(Time.new.to_f*100000).to_i.to_s.concat('.tmp')
    if !File.exists?(tmp_path)
      FileUtils.makedirs(tmp_path)
    end
    FileUtils.cp(sourceFile.path, tmp_file_url)
    tmp_file_url
  end

  def insertOneRow(row)
    has_script=(row[9]=~%r{.*yes.*}i) !=nil ? true : false
    yy=%r{(\d*)}.match(row[10].to_s)[0]
    yy= (yy=='' || yy==nil) ? 0 : yy.to_i
    duration_m=%r{(\d*)\D*(\d*)}.match(row[6].to_s)
    if duration_m == nil
      duration='00:00'
    else
      duration=durationFormat(duration_m)
    end

    lang=row[4]!=nil ? row[4].split(";") : ['None']
    if lang.length==2
      lang_audio=lang[0]
      lang_subtitle=lang[1]
    else
      lang_audio=lang[0]
      lang_subtitle=lang[0]
    end

    f_path=["video", "playonline", row[0].split("-")[0], row[0]].join(File::SEPARATOR)
    f_type=(row[-1]=~%r{vcd}i) !=nil ? "VCD" : "DVD"
    record={}
    record[:meta]={
        :video_number => row[0],
        :title_eng => row[1],
        :title_chs => row[2],
        :audio_language => lang_audio,
        :subtitle_language => lang_subtitle,
        :description => row[3],
        :duration => duration,
        :has_script => has_script,
        :production_year => yy,
        :provider => row[8],
        :file_path => f_path,
        :download_path => f_path,
        :file_name => row[0]+".mp4",
        :img_name => row[0]+".jpeg",
        :play_type => f_type
    }
    record[:trans]= row[5] != nil ? row[5].split(%r{[；;、]}i) : []
    record[:regs]= row[7] != nil ? row[7].split(%r{[；;、]}i) : []
    record[:tags]=row[11] != nil ? row[11].split(%r{[；;、]}i) : []
    record[:tpcs]=row[12] != nil ? row[12].split(%r{[；;、]}i) : []

    insertOneVideoMetadataRecord(record)
  end

  def insertOneVideoMetadataRecord (record)
    video_meta=record[:meta]
    translators=record[:trans]
    regions=record[:regs]
    tags=record[:tags]
    tpcs=record[:tpcs]

    v= VideoMetadata.find_by_video_number(video_meta[:video_number])

    v=VideoMetadata.create(
        :video_number => video_meta[:video_number],
        :title_eng => video_meta[:title_eng],
        :title_chs => video_meta[:title_chs],
        :audio_language => video_meta[:audio_language],
        :subtitle_language => video_meta[:subtitle_language],
        :description => video_meta[:description],
        :duration => video_meta[:duration],
        :has_script => video_meta[:has_script],
        :production_year => video_meta[:production_year],
        :provider => video_meta[:provider],
        :video_statistic_id => s.id,
        :file_path => video_meta[:file_path],
        :download_path => video_meta[:download_path],
        :file_name => video_meta[:file_name],
        :img_name => video_meta[:img_name],
        :play_type => video_meta[:play_type]
    ) if v==nil


    if v!=nil
      regions.each { |place|
        r=Region.where(:place_name => place).first_or_create(:place_name => place)
        if !VideoRegion.exists?(:video_metadata_id => v.id, :region_id => r.id)
          VideoRegion.create(:video_metadata_id => v.id, :region_id => r.id)
        end

      }

      translators.each { |person|
        t=Translator.where(:translator_name => person).first_or_create(:translator_name => person)
        if !VideoTranslator.exists?(:video_metadata_id => v.id, :translator_id => t.id)
          VideoTranslator.create(:video_metadata_id => v.id, :translator_id => t.id)
        end

      }

      tags.each do |tag|
        t=Tag.where(:tag => tag).first_or_create(:tag => tag)
        if !VideoTag.exists?(:video_metadata_id => v.id, :tag_id => t.id)
          VideoTag.create(:video_metadata_id => v.id, :tag_id => t.id)
        end
      end

      tpcs.each do |tpc|
        tpc_chs=formatTopic(tpc)
        tpc_eng= engTopic(tpc_chs)
        c=Topic.where(:topic_chs => tpc_chs).first_or_create(:topic_chs => tpc_chs, :topic_eng => tpc_eng)
        c.video_num+=1
        c.save
        if !VideoTopic.exists?(:video_metadata_id => v.id, :topic_id => c.id)
          VideoTopic.create(:video_metadata_id => v.id, :topic_id => c.id)
        end
      end
    else
      flash[:error]<<"Insert Video "+video_meta[:num]+" failed\n"
    end
  end

  def durationFormat (duration)
    d=duration[2].to_i+duration[1].to_i*60
    ftime=formateSec(d % 60).to_s
    d/=60
    d.to_s+":"+ftime
  end

  def formateSec(sec)
    if sec < 10
      "0"+sec.to_s
    elsif 10<sec && sec<60
      sec.to_s
    end
  end

  def engTopic(tpc)
    case (tpc)
      when "空气污染与治理"
        "Air pollution and its control"
      when "气候变化"
        "Climate change"
      when "自然灾害"
        "Natural disasters"
      when "臭氧层"
        "Ozone"
      when "能源"
        "Energy"
      when "水资源"
        "Water resource"
      when "水污染与治理"
        "Water pollution and its control"
      when "湿地"
        "Wetlands"
      when "河流"
        "Rivers"
      when "湖泊"
        "Lakes"
      when "水坝"
        "Dams"
      when "海洋"
        "Seas & Oceans"
      when "海岸"
        "Beaches"
      when "海岛"
        "Islands"
      when "垃圾污染与治理"
        "Trash pollution and its control"
      when "垃圾管理"
        "Waste management"
      when "工业污染"
        "Industrial pollution"
      when "污染与疾病"
        "Contamination diseases"
      when "核电站"
        "Nuclear power plant"
      when "核废料"
        "Nuclear waste"
      when "废物资源化"
        "Recycling"
      when "环境法规"
        "Environment legislation"
      when "辐射污染"
        "Radiation pollution"
      when "有毒有害物"
        "Toxic waste"
      when "动物世界"
        "Animals"
      when "生态系统"
        "Ecological system"
      when "动物保护"
        "Wildlife protection"
      when "植物"
        "Plants"
      when "森林"
        "Forests"
      when "自然资源保护"
        "Natural resource conservation"
      when "草原"
        "Grassland"
      when "荒漠化与治理"
        "Desertification and its control"
      when "生态恢复与土地保护"
        "Eco-recovery and land resource conservation"
      when "城市环境"
        "Urban environment"
      when "社区"
        "Communities"
      when "公共卫生"
        "Sanitation"
      when "交通"
        "Traffic"
      when "农村"
        "Rural area"
      when "农业"
        "Agriculture"
      when "食物"
        "Food"
      when "人口"
        "Population"
      when "社会"
        "Social society"
      when "战争"
        "Wars"
      when "儿童权益"
        "Children's rights"
      when "大众教育"
        "Public education"
      when "职业培训"
        "Vocational training"
      when "妇女权益"
        "Women's rights"
      when "妇女培训"
        "Women and training"
      when "女童教育"
        "Girl's education"
      when "健康"
        "Public health"
      when "传染病"
        "Infectious disease"
      when "预防艾滋病"
        "AIDS prevention"
      when "生存"
        "Life"
      when "传统"
        "Tradition"
      when "文化"
        "Culture"
      when "国际合作"
        "International cooperation"
      when "科技"
        "Science and technology"
      when "动漫片"
        "Animations"
      when "艺术片"
        "Arts"
      when "公益广告片"
        "Public announcements"
      when "新闻发布片"
        "News release"
      when "环境教育"
        "Environment education"
      when "环保行动"
        "Green activities"
      when "绿色技术"
        "Green technics"
      when "绿色产业"
        "Green industry"
      when "生态旅游"
        "Eco-tourism"
      when "绿色设计"
        "Green design"
      when "经济"
        "Economy"
      when "扶贫"
        "Anti-poverty work"
      when "可持续发展"
        "Sustainable development"
    end
  end

  def formatTopic(tpc)
    case (tpc)
      when "动画片"
        "动漫片"
      when "儿童权利"
        "儿童权益"
      when "公益广告"
        "公益广告片"
      when "环保法规"
        "环境法规"
      when "荒漠化"
        "荒漠化与治理"
      when "空气污染"
        "空气污染与治理"
      when "垃圾污染"
        "垃圾污染与治理"
      when "社区环境"
        "社区"
      when "水污染"
        "水污染与治理"
      else
        tpc
    end
  end
end
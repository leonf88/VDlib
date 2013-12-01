# encoding: utf-8
class LoadUtil
  require 'spreadsheet'

  # import the video information from excel or csv
  def videoImport(file_path)
    defineTopicRelation if GTopic.first.nil?
    if (file_path.last(4)=~%r{\.(xls|csv)}i) !=nil
      begin
        tmp_file_path=getTempFile(file_path)
        row_cnt=0
        case file_path.last(4)
          when %r{\.xls}i
            Spreadsheet.client_encoding='utf-8'
            book=Spreadsheet.open(tmp_file_path)
            sh1=book.worksheet(0)
            sh1.each do |row|
              row_cnt+=1
              insertOneRow(row)
            end
          when %r{\.csv}i
            CSV.foreach(tmp_file_path, :encoding => 'utf-8', :col_sep => ',') do |row|
              row_cnt+=1
              insertOneRow(row)
            end
        end
      ensure
        print("Import record: #{row_cnt}")
        FileUtils.rm(tmp_file_path)
      end
    end
  end

  def docImport(file_path)
    if (file_path.last(4)=~%r{\.(xls|csv)}i) !=nil
      begin
        tmp_file_path=getTempFile(file_path)
        row_cnt=0
        case file_path.last(4)
          when %r{\.xls}i
            Spreadsheet.client_encoding='utf-8'
            book=Spreadsheet.open(tmp_file_path)
            sh1=book.worksheet(0)
            sh1.each do |row|
              row_cnt+=1
              insertDOCOneRow(row)
            end
          when %r{\.csv}i
            CSV.foreach(tmp_file_path, :encoding => 'utf-8', :col_sep => ',') do |row|
              row_cnt+=1
              insertOneRow(row)
            end
        end
      ensure
        print("Import record: #{row_cnt}")
        FileUtils.rm(tmp_file_path)
      end
    end
  end

  def start
    #videoImport("/home/valder/workspace/rails/VDlib/public/excel/影视资料数据库-视频.xls")
    docImport("/home/valder/workspace/rails/VDlib/public/excel/影视资料数据库-文稿.xls")
  end
  private

  # collect the topic and subtopic
  def defineTopicRelation
    cnt=0
    GTopic.create(:topic_chs => "空气", :topic_eng => "Air", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "气候", :topic_eng => "Climate", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "能源", :topic_eng => "Energy", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "淡水", :topic_eng => "Water", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "河湖", :topic_eng => "Rivers", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "海洋", :topic_eng => "Marine", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "垃圾", :topic_eng => "Trash", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "工业", :topic_eng => "Industry", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "辐射与有毒物", :topic_eng => "Radiation & Toxicity", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "生态", :topic_eng => "Ecology", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "自然资源", :topic_eng => "Natural resource", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "荒漠化治理", :topic_eng => "Dersertification control", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "城市", :topic_eng => "Urban", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "农村", :topic_eng => "Countryside", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "社会", :topic_eng => "Society", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "教育", :topic_eng => "Education", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "妇女", :topic_eng => "Women", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "健康", :topic_eng => "Health", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "人文", :topic_eng => "Human", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "合作", :topic_eng => "Cooperation", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "短片", :topic_eng => "Shorts", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "绿色生存", :topic_eng => "Green life", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "环保产业", :topic_eng => "Green business", :priority => cnt); cnt+=1
    GTopic.create(:topic_chs => "可持续经济", :topic_eng => "Sustainable economy", :priority => cnt); cnt+=1
  end

  def getTempFile(src_file_path)
    tmp_dir= File.join(Rails.root, "tmp")
    tmp_path=File.join(tmp_dir, File.basename(src_file_path)+"_"+(Time.new.to_f*100000).to_i.to_s.concat('.tmp'))
    if !File.exists?(tmp_dir)
      FileUtils.makedirs(tmp_dir)
    end
    FileUtils.cp(src_file_path, tmp_path)
    print("Create temporary file: #{File.basename(src_file_path)}")
    tmp_path
  end

  def insertDOCOneRow(row)
    base_dir="/media/新加卷__/Documents/Project/VegaDLib/档案整理/20120912/document/"
    ss=base_dir.size
    file_path=`find #{base_dir} -type f -name "#{row[0]}*"`.strip.split("\n")

    if file_path.length > 1 or file_path.length == 0
      print("#{row[0]} has more than one documents.")
    end
    record={}
    record[:meta]={
        :gsd_number => row[0],
        :title_chs => row[1],
        :doc_path => File.join('files','docs',file_path[0][ss..-1])
    }
    record[:trans]= row[2] != nil ? row[2].split(%r{[；;、]}i) : []
    record[:regs]= row[3] != nil ? row[3].split(%r{[；;、]}i) : []
    record[:tags]=row[4] != nil ? row[4].split(%r{[；;、]}i) : []
    insertOneDOCRecord(record)
  end

  def insertOneDOCRecord(record)

    translators=record[:trans]
    regions=record[:regs]
    tags=record[:tags]

    video_meta=record[:meta]
    d=DMetadata.where(:gsd_number => video_meta[:gsd_number]).first_or_create(
        :gsd_number => video_meta[:gsd_number],
        :title_chs => video_meta[:title_chs],
        :title_eng => "none",
        :doc_path => video_meta[:doc_path],
        :qwords => tags.join(" ")
    )

    p d.errors.messages
    v=VMetadata.find_by_gsv_number(video_meta[:gsd_number])

    if !v.nil?
      d.v_metadata_id=v.id
      d.save
    end

    if d!=nil
      regions.each { |place1|
        place=place1.strip
        r=GRegion.where(:name_chs => place).first_or_create(:name_chs => place)
        if !DMetaRegionship.exists?(:d_metadata_id => d.id, :g_region_id => r.id)
          DMetaRegionship.create(:d_metadata_id => d.id, :g_region_id => r.id)
        end

      }

      translators.each { |person1|
        person=person1.strip
        t=GTranslator.where(:name => person).first_or_create(:name => person)
        if !DMetaTranslatorship.exists?(:d_metadata_id => d.id, :g_translator_id => t.id)
          DMetaTranslatorship.create(:d_metadata_id => d.id, :g_translator_id => t.id)
        end

      }

      tags.each do |tag1|
        p tag1
        tag=tag1.strip
        t=GTag.where(:tag => tag).first_or_create(:tag => tag)
        if !DMetaTagship.exists?(:d_metadata_id => d.id, :g_tag_id => t.id)
          DMetaTagship.create(:d_metadata_id => d.id, :g_tag_id => t.id)
        end
      end
    end
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

    f_path=["files","video", "playonline", row[0].split("-")[0], row[0]].join(File::SEPARATOR)
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
        :file_path => File.join(f_path, row[0]+".mp4"),
        :download_path => f_path,
        :img_name => File.join(f_path, row[0]+".jpeg"),
        :play_type => f_type
    }
    record[:trans]= row[5] != nil ? row[5].split(%r{[；;、]}i) : []
    record[:regs]= row[7] != nil ? row[7].split(%r{[；;、]}i) : []
    record[:tags]=row[11] != nil ? row[11].split(%r{[；;、]}i) : []
    record[:tpcs]=row[12] != nil ? row[12].split(%r{[；;、]}i) : []

    insertOneVideoMetadataRecord(record)
  end

  def insertOneVideoMetadataRecord(record)
    video_meta=record[:meta]
    translators=record[:trans]
    regions=record[:regs]
    tags=record[:tags]
    tpcs=record[:tpcs]

    p=VProvider.where(:provider => video_meta[:provider]).first_or_create(:provider => video_meta[:provider], :detail => video_meta[:provider])
    c=VClarity.where(:clarity => video_meta[:play_type]).first_or_create(:clarity => video_meta[:play_type])

    v=VMetadata.where(:gsv_number => video_meta[:video_number]).first_or_create(
        :gsv_number => video_meta[:video_number],
        :title_eng => video_meta[:title_eng],
        :title_chs => video_meta[:title_chs],
        :audio_language => video_meta[:audio_language],
        :subtitle_language => video_meta[:subtitle_language],
        :description => video_meta[:description],
        :duration => video_meta[:duration],
        :create_date => video_meta[:production_year].to_s,
        :video_path => video_meta[:file_path],
        :img_path => video_meta[:img_name],
        :v_provider_id => p.id,
        :v_clarity_id => c.id,
        :qwords => tags.join(" ")+" "+regions.join(" ")
    )

    if v!=nil
      regions.each { |place1|
        place=place1.strip
        r=GRegion.where(:name_chs => place).first_or_create(:name_chs => place)
        if !VMetaRegionship.exists?(:v_metadata_id => v.id, :g_region_id => r.id)
          VMetaRegionship.create(:v_metadata_id => v.id, :g_region_id => r.id)
        end

      }

      translators.each { |person1|
        person=person1.strip
        t=GTranslator.where(:name => person).first_or_create(:name => person)
        if !VMetaTranslatorship.exists?(:v_metadata_id => v.id, :g_translator_id => t.id)
          VMetaTranslatorship.create(:v_metadata_id => v.id, :g_translator_id => t.id)
        end

      }

      tags.each do |tag1|
        tag=tag1.strip
        t=GTag.where(:tag => tag).first_or_create(:tag => tag)
        if !VMetaTagship.exists?(:v_metadata_id => v.id, :g_tag_id => t.id)
          VMetaTagship.create(:v_metadata_id => v.id, :g_tag_id => t.id)
        end
      end

      tpcs.each do |tpc1|
        tpc=tpc1.strip
        tpc_chs=formatTopic(tpc)
        tpc_eng= engTopic(tpc_chs)
        gt_id=topic2Subtopic(tpc_chs)+1
        c=GSubtopic.where(:topic_chs => tpc_chs).first_or_create(:topic_chs => tpc_chs, :topic_eng => tpc_eng, :g_topic_id => gt_id)

        c.v_count+=1
        c.save
        if !VMetaSubtopicship.exists?(:v_metadata_id => v.id, :g_subtopic_id => c.id)
          VMetaSubtopicship.create(:v_metadata_id => v.id, :g_subtopic_id => c.id)
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

  def topic2Subtopic(tpc)
    case (tpc)
      when "空气污染与治理"
        0
      when "气候变化"
        1
      when "自然灾害"
        1
      when "臭氧层"
        1
      when "能源"
        2
      when "水资源"
        3
      when "水污染与治理"
        3
      when "湿地"
        3
      when "河流"
        4
      when "湖泊"
        4
      when "水坝"
        4
      when "海洋"
        5
      when "海岸"
        5
      when "海岛"
        5
      when "垃圾污染与治理"
        6
      when "垃圾管理"
        6
      when "废物资源化"
        6
      when "工业污染"
        7
      when "污染与疾病"
        7
      when "环境法规"
        7
      when "核电站"
        8
      when "核废料"
        8
      when "辐射污染"
        8
      when "有毒有害物"
        8
      when "动物世界"
        9
      when "生态系统"
        9
      when "动物保护"
        9
      when "植物"
        10
      when "森林"
        10
      when "自然资源保护"
        10
      when "草原"
        11
      when "荒漠化与治理"
        11
      when "生态恢复与土地保护"
        11
      when "城市环境"
        12
      when "社区"
        12
      when "公共卫生"
        12
      when "交通"
        12
      when "农村"
        13
      when "农业"
        13
      when "食物"
        13
      when "人口"
        14
      when "社会"
        14
      when "战争"
        14
      when "儿童权益"
        15
      when "大众教育"
        15
      when "职业培训"
        15
      when "妇女权益"
        16
      when "妇女培训"
        16
      when "女童教育"
        16
      when "健康"
        17
      when "传染病"
        17
      when "预防艾滋病"
        17
      when "生存"
        18
      when "传统"
        18
      when "文化"
        18
      when "国际合作"
        19
      when "科技"
        19
      when "动漫片"
        20
      when "艺术片"
        20
      when "公益广告片"
        20
      when "新闻发布片"
        20
      when "环境教育"
        21
      when "环保行动"
        21
      when "绿色技术"
        21
      when "绿色产业"
        22
      when "生态旅游"
        22
      when "绿色设计"
        22
      when "经济"
        23
      when "扶贫"
        23
      when "可持续发展"
        23
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


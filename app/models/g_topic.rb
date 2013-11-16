class GTopic < ActiveRecord::Base
  attr_accessible :topic_chs, :topic_eng, :priority

  has_many :g_tags
end

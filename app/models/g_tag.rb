class GTag < ActiveRecord::Base
  # Grade 0 is for topic
  # Grade 1 is for video/document
  attr_accessible :tag, :v_count, :d_count

  validates_presence_of :tag

  has_many :d_meta_tagships
  has_many :d_metadatas, :through => :d_meta_tagships

  has_many :v_meta_tagships
  has_many :v_metadatas, :through => :v_meta_tagships

  belongs_to :g_topic
end

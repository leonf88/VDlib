class GTag < ActiveRecord::Base
  attr_accessible :tag, :v_count, :d_count

  validates_presence_of :tag

  has_many :d_meta_tagships
  has_many :d_metadatas, :through => :d_meta_tagships

  has_many :v_meta_tagships
  has_many :v_metadatas, :through => :v_meta_tagships
end

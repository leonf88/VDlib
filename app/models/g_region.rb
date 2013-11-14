class GRegion < ActiveRecord::Base
  attr_accessible :chs_name, :eng_name

  validates_presence_of :chs_name, :eng_name

  has_many :v_meta_regionships
  has_many :v_metadatas, :through => :v_meta_regionships

  has_many :d_meta_regionships
  has_many :d_metadatas, :through => :d_meta_regionships

end

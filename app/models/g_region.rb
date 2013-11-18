# encoding: utf-8
class GRegion < ActiveRecord::Base
  attr_accessible :name_chs, :name_eng

  validates_presence_of :name_chs

  has_many :v_meta_regionships
  has_many :v_metadatas, :through => :v_meta_regionships

  has_many :d_meta_regionships
  has_many :d_metadatas, :through => :d_meta_regionships
end

class GTranslator < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name

  has_many :v_meta_translatorships
  has_many :v_metadatas, :through => :v_meta_translatorships

  has_many :d_meta_translatorships
  has_many :d_metadatas, :through => :d_meta_translatorships

end

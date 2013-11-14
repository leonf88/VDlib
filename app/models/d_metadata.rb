class DMetadata < ActiveRecord::Base

  attr_accessible :gsd_number, :title_eng, :title_chs

  # one-to-many relationship: one document may relate to one video

  belongs_to :v_metadata

  # many-to-many relationship: one document has several tags and translators

  has_many :d_meta_tagships
  has_many :d_tags, :through => :d_meta_tagships
  has_many :d_meta_translatorships
  has_many :d_translators, :through => :d_meta_translatorships

  # here check the parameters correctness

  validates_presence_of :gsd_number, :title_eng, :title_chs
  validates_uniqueness_of :gsd_number

end

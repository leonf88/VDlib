# encoding: utf-8
class DMetadata < ActiveRecord::Base

  attr_accessible :gsd_number, :title_eng, :title_chs, :qwords, :doc_path,
                  :delta

  # one-to-many relationship: one document may relate to one video

  belongs_to :v_metadata

  # many-to-many relationship: one document has several tags and translators

  has_many :d_meta_tagships
  has_many :g_tags, :through => :d_meta_tagships
  has_many :d_meta_translatorships
  has_many :g_translators, :through => :d_meta_translatorships

  # here check the parameters correctness

  validates_presence_of :gsd_number, :title_eng, :title_chs
  validates_uniqueness_of :gsd_number

  define_index do
    indexes :title_eng
    indexes :title_chs
    indexes :qwords

    set_property :delta => false
  end
end

# encoding: utf-8
class VMetadata < ActiveRecord::Base

  # gsv_number is the global serial video number which is used for videos only;
  # video_path is the absolute one-video path;
  # img_path is the directory for multi-pictures or the absolute one-picture path;

  attr_accessible :gsv_number, :title_eng, :title_chs,
                  :audio_language, :subtitle_language, :description, :duration, :create_date, :qwords,
                  :video_path, :img_path,
                  :v_clarity_id, :v_provider_id,
                  :counter,
                  :delta

  # many-to-one relationship: one video has one type clarity, one provider

  belongs_to :v_clarity
  belongs_to :v_provider

  # one-to-many relationship: one video has multiple relative documents

  has_many :d_metadatas

  # many-to-many relationship: one video has several report places, translators and description tags;

  has_many :v_meta_translatorships
  has_many :g_translators, :through => :v_meta_translatorships
  has_many :v_meta_regionships
  has_many :g_regions, :through => :v_meta_regionships
  has_many :v_meta_tagships
  has_many :g_tags, :through => :v_meta_tagships
  has_many :v_meta_subtopicships
  has_many :g_subtopics, :through => :v_meta_subtopicships

  # here check the parameters correctness

  validates_presence_of :gsv_number, :title_eng, :title_chs
  validates_uniqueness_of :gsv_number

  #validates_format_of :video_path,
  #                    :with => %r{^.*\.(jpeg|gif|png)$|^$}i,
  #                    :message => "Image suffix should be GIF, JPEG or PNG."

  validates_format_of :video_path,
                      :with => %r{^.*\.(avi|mp4|flv)$|^$}i,
                      :message => "Video suffix should be AVI, MP4 or FLV."

  validate :valid_date

  def valid_date
    if !create_date.nil?
      # TODO DataTime.parse need check right date time.
      return
      errors.add(:create_date, 'must be a valid datetime') if ((DateTime.parse(create_date) rescue ArgumentError) == ArgumentError)
    end
  end

  define_index do
    indexes :title_eng
    indexes :title_chs
    indexes :description
    indexes :qwords

    set_property :delta => false
  end
end

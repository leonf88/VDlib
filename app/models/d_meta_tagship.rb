# encoding: utf-8
class DMetaTagship < ActiveRecord::Base
  attr_accessible :d_metadata_id, :g_tag_id
  belongs_to :d_metadata
  belongs_to :g_tag
end

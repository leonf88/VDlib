# encoding: utf-8
class DMetaTranslatorship < ActiveRecord::Base
  attr_accessible :d_metadata_id, :g_translator_id
  belongs_to :d_metadata
  belongs_to :g_translator
end

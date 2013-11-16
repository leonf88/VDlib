# encoding: utf-8
class DMetaTranslatorship < ActiveRecord::Base
  belongs_to :d_metadata
  belongs_to :g_translator
end

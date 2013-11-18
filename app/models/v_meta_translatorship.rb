class VMetaTranslatorship < ActiveRecord::Base
  attr_accessible :v_metadata_id, :g_translator_id

  belongs_to :v_metadata
  belongs_to :g_translator
end

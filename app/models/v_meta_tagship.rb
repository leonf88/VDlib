class VMetaTagship < ActiveRecord::Base
  attr_accessible :v_metadata_id, :g_tag_id
  belongs_to :v_metadata
  belongs_to :g_tag
end

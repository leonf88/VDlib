class VMetaRegionship < ActiveRecord::Base
  attr_accessible :v_metadata_id, :g_region_id

  belongs_to :v_metadata
  belongs_to :g_region
end

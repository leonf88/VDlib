class DMetaRegionship < ActiveRecord::Base
  attr_accessible :d_metadata_id, :g_region_id
  belongs_to :d_metadata
  belongs_to :g_region
end

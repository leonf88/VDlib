class DMetaRegionship < ActiveRecord::Base
  belongs_to :d_metadata
  belongs_to :g_region
end

class VMetaRegionship < ActiveRecord::Base
  belongs_to :v_metadata
  belongs_to :g_region
end

class DMetaTagship < ActiveRecord::Base
  belongs_to :d_metadata
  belongs_to :g_tag
end

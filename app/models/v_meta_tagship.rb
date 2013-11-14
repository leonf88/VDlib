class VMetaTagship < ActiveRecord::Base
  belongs_to :v_metadata
  belongs_to :g_tag
end

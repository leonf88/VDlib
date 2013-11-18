class VMetaSubtopicship < ActiveRecord::Base
  attr_accessible :v_metadata_id, :g_subtopic_id

  belongs_to :v_metadata
  belongs_to :g_subtopic
end

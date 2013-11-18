class DMetaSubtopicship < ActiveRecord::Base
  attr_accessible :d_metadata_id, :g_subtopic_id
  belongs_to :d_metadata
  belongs_to :g_subtopic
end

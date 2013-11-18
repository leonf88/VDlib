#ThinkingSphinx::Index.define :DMetadata, :with => :active_record do
#  # fields
#  indexes title_chs, :sortable => true
#  indexes title_eng, :sortable => true
#  indexes qwords, :sortable => true
#
#  # attributes
#  has id, gsd_number, created_at, updated_at
#end
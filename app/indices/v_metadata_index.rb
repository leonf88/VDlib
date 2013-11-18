ThinkingSphinx::Index.define :VMetadata, :with => :active_record do
  # fields
  indexes :title_chs, :sortable => true
  indexes :title_eng, :sortable => true
  indexes :description, :sortable => true
  indexes :qwords, :sortable => true

  # attributes
  has :id, :gsv_number, :created_at, :updated_at
end
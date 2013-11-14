class VClarity < ActiveRecord::Base
  attr_accessible :clarity

  has_many :v_metadatas
end

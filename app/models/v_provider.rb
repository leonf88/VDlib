class VProvider < ActiveRecord::Base
  attr_accessible :provider, :detail

  has_many :v_metadatas
end

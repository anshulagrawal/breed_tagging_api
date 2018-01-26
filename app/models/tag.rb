class Tag < ApplicationRecord
  has_many :breed_tags, dependent: :destroy
  has_many :breeds, through: :breed_tags
end

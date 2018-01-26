class Breed < ApplicationRecord
  has_many :breed_tags
  has_many :tags, through: :breed_tags, dependent: :destroy

  def add_tags!(tag_names)
    # Gather information
    existing_tag_names = self.tags.pluck(:name)
    common_tag_names = tag_names & existing_tag_names
    deletable_tag_names = existing_tag_names - common_tag_names
    new_tag_names = tag_names - common_tag_names
    persisted_tag_names = Tag.where(name: (tag_names - common_tag_names)).pluck(:name)
    # Stage tags
    new_tag_relationship_candidates = Tag.where(name: persisted_tag_names)
    new_tags = (new_tag_names - persisted_tag_names).map do |tag_name|
      Tag.new(name: tag_name)
    end
    # Persist
    BreedTag.clear_tags_for_breed(self, deletable_tag_names)
    self.tags << new_tag_relationship_candidates
    self.tags << new_tags
  end
end

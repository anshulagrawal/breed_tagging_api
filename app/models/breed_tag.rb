class BreedTag < ApplicationRecord
  belongs_to :breed
  belongs_to :tag

  def self.clear_tags_for_breed(breed, tag_names)
    # Delete relationships matching tag_names
    self.joins(:tag).where(breed: breed, tags: {name: tag_names}).delete_all
    # Clear orphaned tags
    clear_orphaned_tags
  end
  def self.clear_orphaned_tags
    Tag.joins("LEFT JOIN breed_tags on breed_tags.tag_id = tags.id").where("breed_tags.id IS NULL").delete_all
  end
end

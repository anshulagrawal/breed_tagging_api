require 'rails_helper'

RSpec.describe :breed, type: :model do
  context "RELATIONSHIP WITH TAGS >>" do
    before :each do
      # Stage a scenario where many to many breed-tag relationships exist, ensure that atleast one breed has one-to-one tag relationship
      breeds = FactoryBot.create_list(:breed, rand(2..20))
      @delete_candidate = breeds.first
      @unique_tags_ids = @delete_candidate.tags.map{|tag| tag.id}
      tag_sharer = breeds.second
      common_tags = tag_sharer.tags
      @common_tags_ids = common_tags.map{|tag| tag.id}
      @delete_candidate.tags << common_tags
      @delete_candidate.destroy
    end
    it "Upon deletion of breed, it deletes tags which got orphaned as a result" do
      expect(Breed.where(id: @delete_candidate.id).count).to eql(0)
      expect(BreedTag.where(tag_id: @unique_tags_ids).count).to eql(0)
    end
    it "Upon deletion of breed, it does not delete tag if another breed is still associated" do
      expect(BreedTag.where(tag_id: @common_tags_ids).count >= @common_tags_ids.length).to eql(true)
    end
  end
  context "ADD TAGS >>" do
    before :all do
      # Stage a scenario where a breed has several existing tags, and some existing + some new tags are provided to add_tag
    end
    it "Adds new tags" do
    end
    it "Removes old tags" do
    end
    it "Sustains common tags" do
    end
    it "Eliminates orphaned tags" do
    end
  end
end

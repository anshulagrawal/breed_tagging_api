require "rails_helper"

RSpec.describe :tag_crud, :type => :request do
  context "CREATE TAGS >> Basic Functionality: " do
    it "Provides route to update tags for breed" do 
      post "/breeds/#{Faker::Number.digit}/tags", params: {
        tag_list: []
      }
      expect(response).to have_http_status(400)
    end
  end
  context "CREATE TAGS >> Behavior: " do
    it "Updates tags for breed" do
      breeds = FactoryBot.create_list(:breed, rand(4..20))
      breed = breeds.third
      old_tags = breed.tags
      common_tags = old_tags.first(rand(1..3))
      tags_request_hash = FactoryBot.build(:tags_request_hash)
      original_tag_length = tags_request_hash[:tags].length
      common_tags.each do |common_tag|
        tags_request_hash[:tags] << {
          id: common_tag.id,
          name: common_tag.name,
        }
      end
      post "/breeds/#{breed.id}/tags", params: tags_request_hash
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["breeds"].length).to eql(1)
      expect(parsed_resp["breeds"].first["tags"].length).to eql(tags_request_hash[:tags].length)
      expect((parsed_resp["breeds"].first["tags"].map{|tag| tag["name"]} - tags_request_hash[:tags].map{|tag| tag[:name]}).length).to eql(0)
      expect((parsed_resp["breeds"].first["tags"].map{|tag| tag["id"]} - common_tags.map{|ct| ct.id}).length).to eql(original_tag_length)
    end
  end
  context "READ TAGS >> Basic Functionality: " do
    it "Provides get all tags route" do 
      get "/tags"
      expect(response).to be_success
    end
    it "Provides read tag by id route" do 
      get "/tags/#{Faker::Number.digit}"
      expect(response).to have_http_status(400)
    end
    it "Provides read tag by breed_id route" do 
      get "/breeds/#{Faker::Number.digit}/tags"
      expect(response).to have_http_status(400)
    end
  end
  context "READ TAGS >> Behavior: " do
    before :each do
      breeds = FactoryBot.create_list(:breed, rand(2..20))
      tags = FactoryBot.create_list(:tag, rand(2..20))
      @num_tags = Tag.all.count
      @all_tag_ids = Tag.all.pluck(:id)
      @tag = tags.second
      @breed = breeds.second
    end
    it "Returns all tags in system" do 
      get "/tags"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["tags"].length).to eql(@num_tags)
      expect((parsed_resp["tags"].map{|tag| tag["id"]} - @all_tag_ids).length).to eql(0)
    end
    it "Returns single tags data based on ID" do 
      get "/tags/#{@tag.id}"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["tags"].length).to eql(1)
      expect((parsed_resp["tags"].map{|tag| tag["id"]} - [@tag.id]).length).to eql(0)
    end
    it "Returns correct tags for breed_id" do 
      get "/breeds/#{@breed.id}/tags"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["tags"].length).to eql(@breed.tags.count)
      expect((parsed_resp["tags"].map{|tag| tag["id"]} - @breed.tags.pluck(:id)).length).to eql(0)
    end
  end
  context "UPDATE TAGS >> Basic Functionality: " do
    it "Provides update tag route (PUT)" do 
      put "/tags/#{Faker::Number.digit}", params: {
        name: ""
      }
      expect(response).to have_http_status(400)
    end
    it "Provides update tag route (PATCH)" do 
      patch "/tags/#{Faker::Number.digit}", params: {
        name: ""
      }
      expect(response).to have_http_status(400)
    end
  end
  context "UPDATE TAGS >> Behavior: " do
    before :each do
      @breed = FactoryBot.create_list(:breed, rand(2..20)).second
    end
    it "Updates tag name and reflects that through breed and tag requests" do
      tag = @breed.tags.first
      original_tag_name = tag.name
      new_tag_name = Faker::Name.name
      patch "/tags/#{tag.id}", params: {
        name: new_tag_name
      }
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["tags"].length).to eql(1)
      @breed.reload
      expect(@breed.tags.where(id: tag.id).first.name).to eql(new_tag_name)
    end
  end
  context "DELETE TAGS >> Basic Functionality: " do
    it "provides delete tag route" do 
      delete "/tags/#{Faker::Number.digit}"
      expect(response).to have_http_status(400)
    end
  end
  context "DELETE TAGS >> Behavior: " do
    before :each do
      @breed = FactoryBot.create_list(:breed, rand(2..20)).second
    end
    it "Deletes tag by ID and all breed associations to it" do
      tag = @breed.tags.first
      delete "/tags/#{tag.id}"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      @breed.reload
      expect(@breed.tags.where(id: tag.id).first.nil?).to eql(true)
    end
  end
end


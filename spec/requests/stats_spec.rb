require "rails_helper.rb"

RSpec.describe :stats, :type => :request do 
  context "BREED STATS >> Basic functionality: " do
    it "Provides end-point to get stats on breeds" do
      get "/breeds/stats"
      expect(response).to be_success
    end
  end
  context "BREED STATS >> Behavior: " do
    it "Retrieves statistics about breeds" do
      breeds = FactoryBot.create_list(:breed, rand(3..20))
      get "/breeds/stats"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["breed_stats"].length).to eql(breeds.length)
      expect(parsed_resp["breed_stats"].map{|breed| [breed["id"], breed["name"], breed["tag_count"], breed["tag_ids"]]}).to eql(breeds.map{|breed|[breed.id, breed.name, breed.tags.count, breed.tags.pluck(:id)]})
    end
  end
  context "TAG STATS >> Basic functionality: " do
    ## Basic functionality
    it "Provides end-point to get stats on tags" do
      get "/tags/stats"
      expect(response).to be_success
    end
  end
  context "TAG STATS >> Behavior: " do
    it "retrieves statistics about tags" do
      breeds = FactoryBot.create_list(:breed, rand(3..20))
      tags = Tag.all
      get "/tags/stats"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["tag_stats"].length).to eql(tags.length)
      expect(parsed_resp["tag_stats"].map{|tag| [tag["id"], tag["name"], tag["breed_count"], tag["breed_ids"]]}).to eql(tags.map{|tag|[tag.id, tag.name, tag.breeds.count, tag.breeds.pluck(:id)]})
    end
  end
end


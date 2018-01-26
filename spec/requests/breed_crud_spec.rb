require "rails_helper"

RSpec.describe :breed_crud, :type => :request do
  context "CREATE BREEDS >> Basic Functionality: " do
    it "Provides create breed route" do 
      post "/breeds", params: FactoryBot.build(:breed_request_hash)
      expect(response.status).to eql(201)
    end
    it "Fails for invalid post data" do 
      post "/breeds", params: {}
      expect(response.status).to eql(400)
    end
  end
  context "CREATE BREEDS >> Behavior: " do
    it "Creates breeds with tags" do 
      request_data = FactoryBot.build(:breed_request_hash)
      post "/breeds", params: request_data
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp.keys.include?("breeds")).to eql(true)
      expect(parsed_resp["breeds"].first["name"]).to eql(request_data[:breed][:name])
      parsed_resp["breeds"].each do |parsed_breed|
        expect(parsed_breed.keys.include?("tags")).to eql(true)
        expect(parsed_breed["tags"].length).to eql(request_data[:breed][:tags].length)
        expect((parsed_breed["tags"].map{|tag| tag["name"]} - request_data[:breed][:tags].map{|tag| tag[:name]}).length).to eql(0)
      end
    end
  end
  context "READ BREEDS >> Basic Functionality: " do
    it "Provides get all breeds route" do
      get "/breeds"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["breeds"].length).to eql(0)
    end
    it "Provides get breed route" do 
      get "/breeds/#{Faker::Number.digit}"
      expect(response).to be_success
    end
  end
  context "READ BREEDS >> Behavior: " do
    it "Reads breed by ID" do 
      breeds = FactoryBot.create_list(:breed, rand(4..20))
      candidate = breeds.third
      get "/breeds/#{candidate.id}"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["breeds"].length).to eql(1)
      expect(parsed_resp["breeds"].first["id"]).to eql(candidate.id)
      expect(parsed_resp["breeds"].first["name"]).to eql(candidate.name)
    end
    it "Reads all breeds" do
      breeds = FactoryBot.create_list(:breed, rand(1..10))
      get "/breeds"
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp["breeds"].map{|breed| breed["id"]}.sort).to eql(breeds.map{|breed| breed.id}.sort)
      expect(parsed_resp["breeds"].map{|breed| breed["name"]}.sort).to eql(breeds.map{|breed| breed.name}.sort)
      expect(parsed_resp["breeds"].map{|breed| breed.has_key?("updated_at")}.any?).to eql(false)
      expect(parsed_resp["breeds"].map{|breed| breed.has_key?("created_at")}.any?).to eql(false)
    end
  end
  context "UPDATE BREEDS >> Basic Functionality: " do
    before(:each) do
      @route = "/breeds/#{rand(1..5000)}"
    end
    it "Provides update breed route (PATCH)" do 
      patch @route, params: FactoryBot.build(:breed_request_hash)
      expect(response.status).to eql(400)
    end
    it "Provides update breed route (PUT)" do 
      put @route, params: FactoryBot.build(:breed_request_hash)
      expect(response.status).to eql(400)
    end
  end
  context "UPDATE BREEDS >> Behavior: " do
    before(:each) do
      breeds = FactoryBot.create_list(:breed, rand(4..20))
      @breed = breeds.third
      @route = "/breeds/#{@breed.id}"
    end
    it "Updates pre-built record with new information" do
      request_data = FactoryBot.build(:breed_request_hash)
      patch @route, params: request_data
      expect(response).to be_success
      parsed_resp = JSON.parse(response.body)
      expect(parsed_resp.keys.include?("breeds")).to eql(true)
      expect(parsed_resp["breeds"].first["name"]).to eql(request_data[:breed][:name])
      parsed_resp["breeds"].each do |parsed_breed|
        expect(parsed_breed.keys.include?("tags")).to eql(true)
        expect(parsed_breed["tags"].length).to eql(request_data[:breed][:tags].length)
        expect((parsed_breed["tags"].map{|tag| tag["name"]} - request_data[:breed][:tags].map{|tag| tag[:name]}).length).to eql(0)
      end
    end
  end
  context "DELETE BREEDS >> Basic Functionality: " do
    it "Provides delete breed route" do 
      delete "/breeds/#{Faker::Number.digit}"
      expect(response).to have_http_status(400)
    end
  end
  context "DELETE BREEDS >> Behavior: " do
    it "Provides delete breed route" do
      breed = FactoryBot.build(:breed)
      breed.save!
      delete "/breeds/#{breed.id}"
      expect(response).to be_success
      expect(Breed.where(id: breed.id).length).to eql(0)
    end
  end
end

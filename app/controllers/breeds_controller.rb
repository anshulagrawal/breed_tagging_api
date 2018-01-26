class BreedsController < ApplicationController
  def _permit_and_extract_request_data(params)
    breed_params = params.require(:breed).permit(:name)
    breed_name = breed_params[:name]
    tag_list = params[:breed].require(:tags)
    raise "Tags must be a list of tag objects" unless tag_list.is_a?(Array)
    tag_names = tag_list.map do |tag|
      tag.require(:name)
      tag[:name]
    end
    return breed_name, tag_names
  end
  def create
    breed_name, tag_names = nil, nil
    safe_whitelist do
      breed_name, tag_names = _permit_and_extract_request_data(params)
      raise InvalidJson.new("Unable to create breed. Possible duplicate") unless Breed.where(name: breed_name).first.blank?
    end
    breed = Breed.new(name: breed_name)
    safe_persist do
      breed.save!
      breed.add_tags!(tag_names)
    end
    render json: HashGen::breeds([breed]), format: :json, status: ResponseCodes::SuccessCodes::Created
  end
  def show
    safe_whitelist do
      params.require(:id)
    end
    render json: HashGen::breeds(Breed.where(id: params[:id])), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  def index
    render json: HashGen::breeds(Breed.all), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  def update
    breed_name, tag_names = nil, nil
    safe_whitelist do
      params.require(:id)
      breed_name, tag_names = _permit_and_extract_request_data(params)
    end
    breed = Breed.where(id: params[:id]).first
    raise InvalidJson.new("Breed not available to update") if breed.blank?
    breed.name = breed_name
    safe_persist do
      breed.save!
      breed.add_tags!(tag_names)
    end
    render json: HashGen::breeds([breed]), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  def destroy
    safe_whitelist do
      params.require(:id)
    end
    breed = Breed.where(id: params[:id]).first
    raise InvalidJson.new("Breed not available to update") if breed.blank?
    breed_id = breed.id
    safe_persist do
      raise "Unable to delete breed with ID: #{breed.id}" unless breed.destroy
    end
    render json: successful_delete_response("Breed", breed_id), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
end
